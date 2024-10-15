#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <bitset>
#include <cmath>
#include <string>

using namespace std;

void print2DMatrix(const vector<vector<double>>& matrix) {
    for (const auto& row : matrix) {
        for (const auto& value : row) {
            cout << value << " ";
        }
        cout << endl;
    }
}

void printMatrix(const vector<double>& matrix) {
    for (const auto& row : matrix) {
        cout << row << endl;
    }
}
void printBit(const vector<bitset<32>>& packed_data) {
    for (const auto& bs : packed_data) {
        cout << bs << endl;
    }
}

vector<bitset<32>> bitPack(const vector<double>& errors) {
    vector<bitset<32>> packed;
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
        packed.push_back(bitset<32>(errBit));
    }
    return packed;
}

vector<vector<double>> readCSV(const string& filename) {
    vector<vector<double>> data;
    ifstream file(filename);
    string line;
    getline(file, line);
    while (getline(file, line)) {
        stringstream ss(line);
        string timestamp, value;
        vector<double> row;
        getline(ss, timestamp, ',');
        while (getline(ss, value, ',')) {
            double number = stod(value);
            double rounded_number = (int)(number * 1000.0) / 1000.0;
            row.push_back(rounded_number);
        }
        data.push_back(row);
    }
    return data;
}

vector<bitset<32>> encodeBlock(const vector<double>& data, vector<double>&errors) {
    errors.push_back(data[0]);
    double prev_value = data[0];
    for (size_t i = 1; i < data.size(); i++) {
        double predicted_value = prev_value;
        double error = data[i] - predicted_value;
        errors.push_back(error);
        prev_value = data[i];
    }
    //Show first row of input after encode (in decimal)
    //printMatrix(errors);
    vector<bitset<32>> packed_data = bitPack(errors);
    return packed_data;
}

vector<double> decode(const vector<bitset<32>>& packed_data, vector<double>& errors) {
    vector<double> decoded_data;
    double prev_value = 0;
    for (const auto& packed : packed_data) {
        bool negative = false;
        if (packed[0] == 1)
            negative = true;
        bitset<32> errorBit = packed >> 1;
        double error = errorBit.to_ulong();
        if (negative)
            error = -error;
        errors.push_back(error);
        double original_value = prev_value + error;
        decoded_data.push_back(original_value/1000);
        prev_value = original_value;
    }
    return decoded_data;
}



int main() {
    string filename = "air_quality_monitors.csv";
    vector<vector<double>> csv_data = readCSV(filename);
    //Show input rounded to 3 decimal 
    //print2DMatrix(csv_data);

    vector<double> data;
    for (const auto& row : csv_data) {
        data.push_back((int)(row[0]*1000));
    }
    //Show first row of input and *1000 so no decimal
    //printMatrix(data);

    vector<double> encodedError;
    vector<bitset<32>> encoded = encodeBlock(data, encodedError);
    //Show first row of input after encode (in binary)
    //printBit(encoded);

    vector<double> decodedErrors;
    vector<double> decoded = decode(encoded, decodedErrors);
    //Show first row of input after encode then decode
    //printMatrix(decoded);

    for (int i = 0; i < decoded.size(); i++) {
        if (data[i] != decoded[i] * 1000)
            cout << "i = " << i << ": " << data[i] << " " << decoded[i] * 1000 << endl;
        //cout << data[i] << " " << decoded[i] << endl;
    }

    return 0;
}
