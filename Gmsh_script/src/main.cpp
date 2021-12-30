#include "../include/MATLAB_DATA_API/MATLAB_DATA_API.h"
#include "mat.h"
#include <Eigen/Dense>
#include <cstdlib>
#include <fstream>
#include <gmsh.h>
#include <iostream>
#include <map>
#include <set>
#include <vector>

using namespace std;
using namespace Eigen;

vector<double> Transfer_Eigen_to_vector(MatrixXf A);

void matread(const char *file, const char *field, std::vector<double> &v);

vector<double> Transfer_Eigen_to_vector(MatrixXd A);
void Matlab_command(string FileKey_m, string FileKey_mat);

int main()
{
    std::vector<double> TMP;
    matread("../../Lines.mat", "Lines_", TMP);

    MatrixXd JXY = MatrixXd::Zero(TMP.size() / 4, 4);

    for (size_t i = 0; i < TMP.size() / 4; ++i)
        for (size_t j = 0; j < 4; ++j)
        {
            size_t ID = j * TMP.size() / 4 + i;

            JXY(i, j) = TMP[ID];
        }

    // mesh
    gmsh::initialize();

    gmsh::model::add("t2");

    double lc = 100;

    int pntID = 0;
    int LineID = 0;
    for (int i = 0; i < JXY.rows(); i++)
    {
        pntID++;
        gmsh::model::occ::addPoint(JXY(i, 0), JXY(i, 1), 0, lc, pntID);
        pntID++;
        gmsh::model::occ::addPoint(JXY(i, 2), JXY(i, 3), 0, lc, pntID);

        LineID++;
        gmsh::model::occ::addLine(pntID - 1, pntID, LineID);
    }

    gmsh::model::occ::synchronize();

    std::vector<std::pair<int, int>> input_entity(LineID);

    for (size_t i = 0; i < input_entity.size(); ++i)
        input_entity[i] = std::make_pair(1, i + 1);

    std::vector<std::pair<int, int>> out;
    std::vector<std::vector<std::pair<int, int>>> outmap;

    gmsh::model::occ::fragment(input_entity, input_entity, out, outmap);
    gmsh::model::occ::synchronize();

    gmsh::model::occ::synchronize();

    gmsh::model::mesh::generate(1);

    //gmsh::fltk::run();
    MatrixXf coordinate_2D;

    std::vector<std::size_t> nodes;
    std::vector<double> coord, coordParam;
    gmsh::model::mesh::getNodes(nodes, coord, coordParam);
    size_t NUM_nodes = coord.size() / 3;

    coordinate_2D.resize(NUM_nodes, 2);

    for (size_t i = 0; i < coord.size(); i += 3)
        coordinate_2D.row(i / 3) << (float)coord[i], (float)coord[i + 1];

    MatrixXf element_2D;

    std::vector<int> elemTypes;
    std::vector<std::vector<std::size_t>> elemTags, elemNodeTags;
    gmsh::model::mesh::getElements(elemTypes, elemTags, elemNodeTags, 1, -1);
    size_t NUM_ele = elemNodeTags[0].size() / 2;
    element_2D.resize(NUM_ele, 2);

    for (size_t i = 0; i < elemNodeTags[0].size(); i += 2)
        element_2D.row(i / 2) << (float)elemNodeTags[0][i],
            (float)elemNodeTags[0][i + 1];

    gmsh::finalize();

    vector<double> JXY_vec = Transfer_Eigen_to_vector(coordinate_2D);
    vector<double> JM_vec = Transfer_Eigen_to_vector(element_2D);

    MATLAB_DATA_API ML;
    string ASd = "../../mesh_2D.mat";
    ML.Write_mat(ASd, "w", JXY_vec.size(),
                 coordinate_2D.rows(), coordinate_2D.cols(),
                 JXY_vec, "JXY_2D");

    ML.Write_mat(ASd, "u", JM_vec.size(),
                 element_2D.rows(), element_2D.cols(),
                 JM_vec, "JM_2D");

    return 0;
};

void matread(const char *file, const char *field, std::vector<double> &v)
{
    // open MAT-file
    MATFile *pmat = matOpen(file, "r");
    if (pmat == NULL)
    {
        cout << "NO file\n";
        return;
    }

    // extract the specified variable
    mxArray *arr = matGetVariable(pmat, field);
    if (arr != NULL && mxIsDouble(arr) && !mxIsEmpty(arr))
    {

        // copy data
        mwSize num = mxGetNumberOfElements(arr);
        double *pr = mxGetPr(arr);

        if (pr != NULL)
        {
            v.reserve(num); //is faster than resize :-)
            v.assign(pr, pr + num);
        }
    }

    // cleanup
    mxDestroyArray(arr);
    matClose(pmat);
}

vector<double> Transfer_Eigen_to_vector(MatrixXd A)
{
    vector<double> B(A.size());

    for (int i = 0; i < A.rows(); ++i)
        for (int j = 0; j < A.cols(); ++j)
        {
            size_t ID = j * A.rows() + i;
            B[ID] = A(i, j);
        }

    return B;
};

void Matlab_command(string FileKey_m, string FileKey_mat)
{
    std::ofstream oss(FileKey_m, ios::out);
    oss << "clc;\nclose all;\nclear all;";
    oss << "currentPath = fileparts(mfilename('fullpath'));\n";
    oss << "load('" << FileKey_mat << "');\n\n";

    oss << "element3D = [JM_3D(:, [1, 2, 3]), JM_3D(:, [1, 2, 4]), JM_3D(:, [2, 3, 4]), JM_3D(:, [3, 1, 4])];\n";
    oss << "figure(1); view(3); hold on\n";
    oss << "title('one element (global node; local node)')\nxlabel('x (mm)'); ylabel('y (mm)'); zlabel('z (mm)'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([1:1], [1 2 3]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'r'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([1:1], [4 5 6]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'r'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([1:1], [7 8 9]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'r'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([1:1], [10 11 12]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'r'); hold on\n";
    oss << "for i = 1:size(JM_3D, 2)\n";
    oss << "\tnode = JM_3D(1, i);\n";
    oss << "\ttext(JXY_3D(node, 1), JXY_3D(node, 2), JXY_3D(node, 3), [num2str(node), '; ', num2str(i)], 'fontsize', 16);\n";
    oss << "end\n\n";

    oss << "figure(2); view(3); hold on\n";
    oss << "title('3D mesh')\nxlabel('x (mm)'); ylabel('y (mm)'); zlabel('z (mm)'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([1:Outer_volume], [1 2 3]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'r'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([1:Outer_volume], [4 5 6]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'r'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([1:Outer_volume], [7 8 9]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'r'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([1:Outer_volume], [10 11 12]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'r'); hold on\n";
    oss << "\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([Outer_volume + 1 : size(element3D, 1)], [1 2 3]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'b'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([Outer_volume + 1 : size(element3D, 1)], [4 5 6]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'b'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([Outer_volume + 1 : size(element3D, 1)], [7 8 9]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'b'); hold on\n";
    oss << "patch('Vertices', JXY_3D, 'Faces', element3D([Outer_volume + 1 : size(element3D, 1)], [10 11 12]), 'FaceVertexCData', zeros(size(JXY_3D, 1), 1), 'FaceColor', 'interp', 'EdgeAlpha', 1, 'facealpha', 0, 'edgecolor', 'b'); hold on\n";

    oss << "\n\n";

    oss << "h5create([currentPath, '/eye_ball_mesh.h5'], '/pnt', size(JXY_3D));\n";
    oss << "h5write([currentPath, '/eye_ball_mesh.h5'], '/pnt', JXY_3D);\n";
    oss << "h5create([currentPath, '/eye_ball_mesh.h5'], '/ele', size(JM_3D));\n";
    oss << "h5write([currentPath, '/eye_ball_mesh.h5'], '/ele', JM_3D);\n";
    oss << "h5create([currentPath, '/eye_ball_mesh.h5'], '/tag', size(Tag_3D));\n";
    oss << "h5write([currentPath, '/eye_ball_mesh.h5'], '/tag', Tag_3D);\n";
    oss.close();
}


vector<double> Transfer_Eigen_to_vector(MatrixXf A)
{
    vector<double> B(A.size());

    for (int i = 0; i < A.rows(); ++i)
        for (int j = 0; j < A.cols(); ++j)
        {
            size_t ID = j * A.rows() + i;
            B[ID] = (double)A(i, j);
        }

    return B;
};