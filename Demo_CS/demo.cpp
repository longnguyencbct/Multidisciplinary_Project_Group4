#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <bitset>
#include <cmath>
#include <string>
#include <iomanip>

using namespace std;
void print2DMatrix(const vector<vector<double>>& matrix) {
    for (const auto& row : matrix) {
        for (const auto& value : row) {
            cout << fixed << setprecision(0) << value << " ";
        }
        cout << endl;
    }
}

void printMatrix(const vector<double>& matrix) {
    for (const auto& row : matrix) {
        cout << fixed << setprecision(0) << row << ", ";
    }
    cout << endl;
}
void printBit(const vector<bitset<32>>& packed_data) {
    for (const auto& bs : packed_data) {
        cout << bs << endl;
    }
}
void bitPack1(const vector<double>& errors) {
    string name = "encode(binary form).txt";
    string nameDec = "encode(decimal form).txt";
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


vector<vector<double>> readCSV(const string& filename, int& count) {
    vector<vector<double>> data;
    ifstream file(filename);
    string line;
    getline(file, line);

    if (getline(file, line)) {
        stringstream ss(line);
        string value,timestamp;
        vector<double> row;

        getline(ss, timestamp, ',');
        timestamp.erase(remove(timestamp.begin(), timestamp.end(), '-'), timestamp.end());
        timestamp.erase(remove(timestamp.begin(), timestamp.end(), ':'), timestamp.end());
        timestamp.erase(remove(timestamp.begin(), timestamp.end(), ' '), timestamp.end());
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
        timestamp.erase(remove(timestamp.begin(), timestamp.end(), '-'), timestamp.end());
        timestamp.erase(remove(timestamp.begin(), timestamp.end(), ':'), timestamp.end());
        timestamp.erase(remove(timestamp.begin(), timestamp.end(), ' '), timestamp.end());
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

void encode(const vector<double>& data, vector<double>& prev_data) {
    vector<double> errors;
    for (size_t i = 0; i < data.size(); i++) {
        double cur = data[i];
        if (i != 0)
            cur *= 1000;
        double error = cur - prev_data[i];
        errors.push_back(error);
        prev_data[i] = cur;
    }
    //printMatrix(errors);
    bitPack1(errors);
    return ;
}

void decode(vector<double>& prev_decode) {
    string outName = "decode.txt";
    ofstream outFile(outName);

    string inName = "encode(binary form).txt";
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
            double original_value = prev_decode[row] + error;
            string date = to_string(static_cast<int>(original_value));
            date = "202" + date;
            date.insert(4, "-");
            date.insert(7, "-");
            date.insert(10, " ");
            date.insert(13, ":");
            outFile << date << " ";
            prev_decode[row] = original_value;
        }
        else {
            bool negative = false;
            if (value[0] == 1)
                negative = true;
            bitset<32> errorBit = value >> 1;
            double error = errorBit.to_ulong();
            if (negative)
                error = -error;
            double original_value = prev_decode[row] + error;
            double outputValue = original_value / 1000;
            outFile << original_value / 1000 << " ";
            prev_decode[row] = original_value;
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


int main() {
    string filename = "air_quality_monitors.csv";
    int count = 0;
    vector<vector<double>> csv_data = readCSV(filename,count);
    //Show input rounded to 3 decimal 
    //print2DMatrix(csv_data);


    vector<double> prev_data;
    for (int i = 0; i < count + 1; i++) {
        prev_data.push_back(0.0);
    }
    for (int i = 0; i < csv_data.size(); i++) {
        vector<double> row = csv_data[i];
        encode(row,prev_data);
    }

    vector<double> prev_decode;
    for (int i = 0; i < count + 1; i++) {
        prev_decode.push_back(0.0);
    }
    decode(prev_decode);

    return 0;
}
