import FMDB

class DatabaseHelper {
    static let shared = DatabaseHelper()
    private var db: FMDatabase?

    private init(){}
    
    func initializeDatabase() {
            // Define the database path
            let fileURL = try! FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("UsersDatabase.sqlite")
        
        print(fileURL)
            // Initialize the FMDatabase object
            db = FMDatabase(url: fileURL)
            
            // Open the database
            if db!.open() {
                print("Database opened successfully")
                
                // Create a table (if not exists)
                let createTableQuery = """
                CREATE TABLE IF NOT EXISTS Users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    firstName TEXT NOT NULL,
                    lastName TEXT,
                    email TEXT UNIQUE NOT NULL,
                    contactNumber TEXT,
                    password TEXT NOT NULL,
                    dateOfBirth TEXT,
                    gender TEXT NOT NULL,
                    country TEXT,
                    termsAccepted INTEGER NOT NULL
                );
                """
                
                if db!.executeUpdate(createTableQuery, withArgumentsIn: []) {
                    print("Table created successfully")
                } else {
                    print("Failed to create table: \(db!.lastErrorMessage())")
                }
                
                // Close the database
                db!.close()
            } else {
                print("Unable to open database")
            }
        }


//    private func openDatabase() {
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UsersDatas.sqlite")
//
//        db = FMDatabase(path: fileURL.path)
//
//        if db?.open() == true {
//            print("Database opened successfully")
//        } else {
//            print("Failed to open database")
//        }
//    }
//
//    private func createTable() {
//        let createTableSQL = """
//        CREATE TABLE IF NOT EXISTS Users (
//            id INTEGER PRIMARY KEY AUTOINCREMENT,
//            firstName TEXT NOT NULL,
//            lastName TEXT,          -- Optional
//            email TEXT NOT NULL UNIQUE,
//            country TEXT,           -- Optional
//            gender TEXT,            -- Optional
//            termsAccepted INTEGER NOT NULL
//        )
//        """
//        do {
//            try db?.executeUpdate(createTableSQL, values: nil)
//            print("Table created successfully")
//        } catch {
//            print("Failed to create table: \(error.localizedDescription)")
//        }
//    }

    func insertUser(firstName: String, lastName: String?, email: String, contactNumber: String?, password: String, dateOfBirth: String?, gender: String, country: String?, termsAccepted: Bool) -> Bool {
            if db!.open() {
                let insertQuery = """
                INSERT INTO Users (firstName, lastName, email, contactNumber, password, dateOfBirth, gender, country, termsAccepted)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
                """
                
                let termsValue = termsAccepted ? 1 : 0
                
                do {
                    try db!.executeUpdate(insertQuery, values: [firstName, lastName ?? "", email, contactNumber ?? "", password, dateOfBirth ?? "", gender, country ?? "", termsValue])
                    print("User inserted successfully")
                    db!.close()
                    return true
                } catch {
                    print("Failed to insert user: \(error.localizedDescription)")
                    db!.close()
                    return false
                }
            } else {
                print("Unable to open database")
                return false
            }
        }
    func fetchUser(byEmail email: String) -> User? {
            var user: User?
            if db!.open() {
                let query = "SELECT * FROM Users WHERE email = ?"
                do {
                    let results = try db!.executeQuery(query, values: [email])
                    if results.next() {
                        user = User(
                            firstName: results.string(forColumn: "firstName") ?? "",
                            lastName: results.string(forColumn: "lastName"),
                            email: results.string(forColumn: "email") ?? "",
                            contactNumber: results.string(forColumn: "contactNumber"),
                            password: results.string(forColumn: "password") ?? "",
                            dateOfBirth: results.string(forColumn: "dateOfBirth"),
                            gender: results.string(forColumn: "gender") ?? "",
                            country: results.string(forColumn: "country"),
                            termsAccepted: results.bool(forColumn: "termsAccepted")
                        )
                    }
                } catch {
                    print("Failed to fetch user: \(error.localizedDescription)")
                }
                db!.close()
            }
            return user
        }

}

struct User {
    let firstName: String
    let lastName: String?
    let email: String
    let contactNumber: String?
    let password: String
    let dateOfBirth: String?
    let gender: String
    let country: String?
    let termsAccepted: Bool
}

