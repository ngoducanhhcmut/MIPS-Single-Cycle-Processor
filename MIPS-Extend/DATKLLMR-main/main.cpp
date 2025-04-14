#include <iostream>
#include <fstream>
#include <string>
using namespace std;
int main() {
    fstream myfile;
    myfile.open("D:\\helper\\data.txt",ios::in);
    string line;
    if (myfile)
    {
        int i=0;

        while ( getline (myfile,line) )
        {
            cout << "memory["<<i<<"]=32'h"<<line << ";\n";
            i++;
        }
        myfile.close();
    }

}
