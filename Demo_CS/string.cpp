// string.cpp
#include <iostream>
#include <sstream>
#include <vector>
#include <bitset>
#include <string>
#include <iomanip>
#include <fstream>


#include <pybind11/pybind11.h>  // Include pybind11 headers
#include <pybind11/stl.h>       // Include support for STL containers

namespace py = pybind11;
using namespace std;

// Global previous data vector
vector<double> prev_data;

// Function to initialize prev_data
void init_prev_data(int count) {
    prev_data.clear();
    for (int i = 0; i < count; i++) {
        prev_data.push_back(0.0);
    }
}

// Function to encode a single line
vector<string> encode_string(const string& line) {
    vector<double> errors;
    stringstream ss(line);
    string timestamp, value;
    vector<double> row;

    // Extract timestamp and convert to numeric format
    getline(ss, timestamp, ',');
    string newTimestamp;
for (char c : timestamp) {
    if (c != '-' && c != ':' && c != ' ') {
        newTimestamp += c;
    }
}
string modifiedTimestamp = newTimestamp.substr(3);
    double timestampInt = (stod(modifiedTimestamp) / 100);
    row.push_back(timestampInt);

    // Extract other values and convert them to numbers
    while (getline(ss, value, ',')) {
        double number = stod(value);
        double rounded_number;
        if (number * 1000.0 >= (int)(number * 1000.0) + 0.5) {
            rounded_number = (int)(number * 1000.0 + 1);
        } else {
            rounded_number = (int)(number * 1000.0);
        }
        row.push_back(rounded_number);
    }

    // Initialize prev_data if it's empty
    if (prev_data.empty()) {
        init_prev_data(row.size());
    }

    // Calculate errors
    for (size_t i = 0; i < prev_data.size(); i++) {
        double cur = row[i];
        double error = cur - prev_data[i];
        errors.push_back(error);
        prev_data[i] = cur;
    }

    // Perform bit packing and convert to binary strings
    vector<string> encoded_errors;
    for (double err : errors) {
        bool negative = false;
        if (err < 0) {
            negative = true;
            err = -err;
        }

        // Pack the error into a bitset
        bitset<32> errBit(static_cast<uint32_t>(err));
        errBit = errBit << 1;  // Shift left by 1
        if (negative)
            errBit.set(0);  // Set the last bit if the value is negative

        // Convert the bitset to a binary string and add it to the result
        encoded_errors.push_back(errBit.to_string());
    }
    return encoded_errors;
}


// Binding code
PYBIND11_MODULE(sprintz_encoder, m) {
    m.def("encode_string", &encode_string, "Encode a single line using Sprintz encoding");
}

using namespace std;
void print2DMatrix_string(const vector<vector<double>>& matrix) {
    for (const auto& row : matrix) {
        for (const auto& value : row) {
            cout << fixed << setprecision(3) << value << " ";
        }
        cout << endl;
    }
}

void printMatrix_string(const vector<double>& matrix) {
    for (const auto& row : matrix) {
        cout << fixed << setprecision(3) << row << ", ";
    }
    cout << endl;
}
void printBit_string(const vector<bitset<32>>& packed_data) {
    for (const auto& bs : packed_data) {
        cout << bs << endl;
    }
}
void bitPack1_string(const vector<double>& errors) {
    string name = "encode_string(binary form).txt";
    string nameDec = "encode_string(decimal form).txt";
    ofstream outFile(name, ios::app | ios::binary);
    ofstream outFileDec(nameDec, ios::app);
    if (!outFile) {
        cerr << "Cannot open: " << name << endl;
        return ;
    }
    if (outFile.is_open() && outFileDec.is_open()) {
        for (double err : errors) {
            bool negative = false;
            if (err < 0) {
                negative = true;
                err = -err;
            }
            
            bitset<32> errBit = bitset<32>(err);
            errBit = errBit << 1;
            if (negative)
                errBit |= bitset<32>(1);
            // This last bit = 1 mean negative and 0 is positive
            outFileDec << errBit << " ";
            //cout << errBit << " ";
            //cout << fixed << setprecision(0) << err << " ";
            outFile.write(reinterpret_cast<const char*>(&errBit), sizeof(errBit));
        }
        //cout << endl;
        outFileDec << endl;
        outFile.close();
        outFileDec.close();
    }
    return;
}

vector<vector<double>> readCSV_string(const string& filename, int& count) {
    vector<vector<double>> data;
    ifstream file(filename);
    string line;
    getline(file, line);

    if (getline(file, line)) {
        stringstream ss(line);
        string value,timestamp;
        vector<double> row;

        getline(ss, timestamp, ',');
        // Example code to modify `timestamp` by removing certain characters:
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), '-'), timestamp.end());
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), ':'), timestamp.end());
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), ' '), timestamp.end());
        string modifiedTimestamp = timestamp.substr(3);
        double timestampInt = (stod(modifiedTimestamp) / 100);
        row.push_back(timestampInt);


        while (getline(ss, value, ',')) {
            double number = stod(value);
            double rounded_number;
            if (number * 1000.0 >= (int)(number * 1000.0) + 0.5) {
                rounded_number = (int)(number * 1000.0 + 1) / 1000.0;
            }
            else
                rounded_number = (int)(number * 1000.0) / 1000.0;
            row.push_back(rounded_number);
            count++;
        }
        data.push_back(row);
    }

    while (getline(file, line)) {
        stringstream ss(line);
        string timestamp, value;
        vector<double> row;


        getline(ss, timestamp, ',');
        // Example code to modify `timestamp` by removing certain characters:
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), '-'), timestamp.end());
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), ':'), timestamp.end());
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), ' '), timestamp.end());
        string modifiedTimestamp = timestamp.substr(3);
        double timestampInt = (stod(modifiedTimestamp) / 100);
        row.push_back(timestampInt);


        while (getline(ss, value, ',')) {
            double number = stod(value);
            double rounded_number;
            if (number * 1000.0 >= (int)(number * 1000.0) + 0.5) {
                rounded_number = (int)(number * 1000.0 + 1) / 1000.0;
            }
            else
                rounded_number = (int)(number * 1000.0) / 1000.0;
            row.push_back(rounded_number);
        }
        data.push_back(row);
    }
    return data;
}

void encode_string(const string& line, vector<double>& prev_data) {
    vector<double> errors;
    stringstream ss(line);
    string timestamp, value;
    vector<double> row;

    getline(ss, timestamp, ',');
        // Example code to modify `timestamp` by removing certain characters:
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), '-'), timestamp.end());
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), ':'), timestamp.end());
        // timestamp.erase(std::remove(timestamp.begin(), timestamp.end(), ' '), timestamp.end());
    string modifiedTimestamp = timestamp.substr(3);
    double timestampInt = (stod(modifiedTimestamp) / 100);
    row.push_back(timestampInt);

    while (getline(ss, value, ',')) {
        double number = stod(value);
        double rounded_number;
        if (number * 1000.0 >= (int)(number * 1000.0) + 0.5) {
            rounded_number = (int)(number * 1000.0 + 1);
        }
        else
            rounded_number = (int)(number * 1000.0);
        row.push_back(rounded_number);
    }
    for (int i = 0; i < prev_data.size(); i++) {
        double cur = row[i];
        double error = cur - prev_data[i];
        errors.push_back(error);
        prev_data[i] = cur;
    }
    bitPack1_string(errors);
    return ;
}

void decode_string(vector<double>& prev_decode_string) {
    string outName = "decode_string.txt";
    ofstream outFile(outName);

    string inName = "encode_string(binary form).txt";
    ifstream inFile(inName, ios::binary);

    if (!inFile) {
        cerr << "Can not open " << inName << endl;
        return;
    }

    vector<bitset<32>> data;
    bitset<32> errBit;

    while (inFile.read(reinterpret_cast<char*>(&errBit), sizeof(errBit))) {
        data.push_back(errBit);
    }

    inFile.close();
    int row = 0;
    for (const auto& value : data) {
        if (row == 0) {
            bitset<32> errorBit = value >> 1;
            double error = errorBit.to_ulong(); 
            double original_value = prev_decode_string[row] + error;
            string date = to_string(static_cast<int>(original_value));
            date = "202" + date;
            date.insert(4, "-");
            date.insert(7, "-");
            date.insert(10, " ");
            date.insert(13, ":");
            outFile << date << " ";
            prev_decode_string[row] = original_value;
        }
        else {
            bool negative = false;
            if (value[0] == 1)
                negative = true;
            bitset<32> errorBit = value >> 1;
            double error = errorBit.to_ulong();
            if (negative)
                error = -error;
            double original_value = prev_decode_string[row] + error;
            double outputValue = original_value / 1000;
            outFile << original_value / 1000 << " ";
            prev_decode_string[row] = original_value;
        }
        row++;
        if (row == 4) {
            row = 0;
            outFile << endl;
        }
    }
    inFile.close();
    return ;
}

// int main() {
//     string filename = "air_quality_monitors.csv";
//     ifstream file(filename);
//     string line;
//     getline(file, line);
//     stringstream ss(line);
//     string headline;
//     int count = 0;
//     while (getline(ss, headline, ',')) {
//         count++;
//     }

//     vector<double> prev_data;
//     for (int i = 0; i < count; i++) {
//         prev_data.push_back(0.0);
//     }
//     while (getline(file, line)) {
//         encode_string(line, prev_data);
//     }


//     vector<double> prev_decode_string;
//     for (int i = 0; i < count; i++) {
//         prev_decode_string.push_back(0.0);
//     }
//     decode_string(prev_decode_string);

//     return 0;
// }
