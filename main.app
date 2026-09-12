/*
    STUDENT MANAGEMENT SYSTEM
    --------------------------
    A console-based Student Management System in C++.
    Features: Add, Update, Delete, Display student records.
    Data is stored persistently using file handling (students.txt).

    --------------------------------------------------------------
    SAMPLE OUTPUT (after compiling and running the program)
    --------------------------------------------------------------

    ========================================
          STUDENT MANAGEMENT SYSTEM
    ========================================
    1. Add Student
    2. Display All Students
    3. Update Student
    4. Delete Student
    5. Exit
    ========================================
    Enter your choice: 1

    --- Add New Student ---
    Enter Roll Number: 101
    Enter Name: Arun
    Enter Department: CSE
    Enter Marks: 85.5

    Student added successfully!

    Enter your choice: 1

    --- Add New Student ---
    Enter Roll Number: 102
    Enter Name: Divya
    Enter Department: ECE
    Enter Marks: 91

    Student added successfully!

    Enter your choice: 2

    --------------------------------------------------------------
    Roll No   Name                Department          Marks
    --------------------------------------------------------------
    101       Arun                CSE                 85.5
    102       Divya               ECE                 91
    --------------------------------------------------------------
    Total Records: 2

    Enter your choice: 3
    Enter Roll Number of student to update: 101
    Current Details -> Name: Arun, Department: CSE, Marks: 85.5
    Enter New Name: Arun Kumar
    Enter New Department: CSE
    Enter New Marks: 88

    Student record updated successfully!

    Enter your choice: 4
    Enter Roll Number of student to delete: 102
    Deleting -> Name: Divya, Department: ECE

    Student record deleted successfully!

    Enter your choice: 2

    --------------------------------------------------------------
    Roll No   Name                Department          Marks
    --------------------------------------------------------------
    101       Arun Kumar          CSE                 88
    --------------------------------------------------------------
    Total Records: 1

    Enter your choice: 5
    Exiting... Thank you!
    --------------------------------------------------------------
*/

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <iomanip>
#include <limits>

using namespace std;

const string FILENAME = "students.txt";

// ---------- Student structure ----------
struct Student {
    int roll;
    string name;
    string department;
    float marks;
};

// ---------- Function Prototypes ----------
void showMenu();
void addStudent();
void displayStudents();
void updateStudent();
void deleteStudent();
vector<Student> loadStudents();
void saveStudents(const vector<Student>& students);
int getValidInt(const string& prompt);
float getValidFloat(const string& prompt);
string getValidString(const string& prompt);

// ---------- Main ----------
int main() {
    int choice;

    do {
        showMenu();
        choice = getValidInt("Enter your choice: ");

        switch (choice) {
            case 1: addStudent(); break;
            case 2: displayStudents(); break;
            case 3: updateStudent(); break;
            case 4: deleteStudent(); break;
            case 5: cout << "\nExiting... Thank you!\n"; break;
            default: cout << "\nInvalid choice! Please try again.\n";
        }

        if (choice != 5) {
            cout << "\nPress Enter to continue...";
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cin.get();
        }

    } while (choice != 5);

    return 0;
}

// ---------- Menu ----------
void showMenu() {
    cout << "\n========================================\n";
    cout << "      STUDENT MANAGEMENT SYSTEM\n";
    cout << "========================================\n";
    cout << "1. Add Student\n";
    cout << "2. Display All Students\n";
    cout << "3. Update Student\n";
    cout << "4. Delete Student\n";
    cout << "5. Exit\n";
    cout << "========================================\n";
}

// ---------- Input Validation Helpers ----------
int getValidInt(const string& prompt) {
    int value;
    while (true) {
        cout << prompt;
        cin >> value;
        if (cin.fail()) {
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Invalid input! Please enter a number.\n";
        } else {
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            return value;
        }
    }
}

float getValidFloat(const string& prompt) {
    float value;
    while (true) {
        cout << prompt;
        cin >> value;
        if (cin.fail()) {
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Invalid input! Please enter a valid number.\n";
        } else {
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            return value;
        }
    }
}

string getValidString(const string& prompt) {
    string value;
    cout << prompt;
    getline(cin, value);
    return value;
}

// ---------- File Handling: Load ----------
vector<Student> loadStudents() {
    vector<Student> students;
    ifstream file(FILENAME);
    string line;

    if (!file) return students; // file may not exist yet

    while (getline(file, line)) {
        if (line.empty()) continue;
        stringstream ss(line);
        string token;
        Student s;

        getline(ss, token, '|'); s.roll = stoi(token);
        getline(ss, token, '|'); s.name = token;
        getline(ss, token, '|'); s.department = token;
        getline(ss, token, '|'); s.marks = stof(token);

        students.push_back(s);
    }

    file.close();
    return students;
}

// ---------- File Handling: Save ----------
void saveStudents(const vector<Student>& students) {
    ofstream file(FILENAME, ios::trunc);
    for (const auto& s : students) {
        file << s.roll << "|" << s.name << "|" << s.department << "|" << s.marks << "\n";
    }
    file.close();
}

// ---------- Add Student ----------
void addStudent() {
    vector<Student> students = loadStudents();
    Student s;

    cout << "\n--- Add New Student ---\n";
    s.roll = getValidInt("Enter Roll Number: ");

    // Check for duplicate roll number
    for (const auto& st : students) {
        if (st.roll == s.roll) {
            cout << "Error: A student with this Roll Number already exists!\n";
            return;
        }
    }

    s.name = getValidString("Enter Name: ");
    s.department = getValidString("Enter Department: ");
    s.marks = getValidFloat("Enter Marks: ");

    students.push_back(s);
    saveStudents(students);

    cout << "\nStudent added successfully!\n";
}

// ---------- Display Students ----------
void displayStudents() {
    vector<Student> students = loadStudents();

    if (students.empty()) {
        cout << "\nNo student records found.\n";
        return;
    }

    cout << "\n--------------------------------------------------------------\n";
    cout << left << setw(10) << "Roll No" << setw(20) << "Name"
         << setw(20) << "Department" << setw(10) << "Marks" << "\n";
    cout << "--------------------------------------------------------------\n";

    for (const auto& s : students) {
        cout << left << setw(10) << s.roll << setw(20) << s.name
             << setw(20) << s.department << setw(10) << s.marks << "\n";
    }
    cout << "--------------------------------------------------------------\n";
    cout << "Total Records: " << students.size() << "\n";
}

// ---------- Update Student ----------
void updateStudent() {
    vector<Student> students = loadStudents();

    if (students.empty()) {
        cout << "\nNo student records found.\n";
        return;
    }

    int roll = getValidInt("\nEnter Roll Number of student to update: ");
    bool found = false;

    for (auto& s : students) {
        if (s.roll == roll) {
            found = true;
            cout << "Current Details -> Name: " << s.name
                 << ", Department: " << s.department
                 << ", Marks: " << s.marks << "\n";

            s.name = getValidString("Enter New Name: ");
            s.department = getValidString("Enter New Department: ");
            s.marks = getValidFloat("Enter New Marks: ");

            cout << "\nStudent record updated successfully!\n";
            break;
        }
    }

    if (!found) {
        cout << "\nStudent with Roll Number " << roll << " not found!\n";
    } else {
        saveStudents(students);
    }
}

// ---------- Delete Student ----------
void deleteStudent() {
    vector<Student> students = loadStudents();

    if (students.empty()) {
        cout << "\nNo student records found.\n";
        return;
    }

    int roll = getValidInt("\nEnter Roll Number of student to delete: ");
    bool found = false;

    for (size_t i = 0; i < students.size(); i++) {
        if (students[i].roll == roll) {
            found = true;
            cout << "Deleting -> Name: " << students[i].name
                 << ", Department: " << students[i].department << "\n";

            students.erase(students.begin() + i);
            saveStudents(students);
            cout << "\nStudent record deleted successfully!\n";
            break;
        }
    }

    if (!found) {
        cout << "\nStudent with Roll Number " << roll << " not found!\n";
    }
}
