import FMDB

class DatabaseHelper {
    static let shared = DatabaseHelper()
    private var db: FMDatabase?

    private init(){}
    
    func initializeDatabase() {
        // Define the database path
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Users.sqlite")
        
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
                termsAccepted INTEGER NOT NULL,
                profileImage BLOB
            );
            """
            
            if db!.executeUpdate(createTableQuery, withArgumentsIn: []) {
                print("Table created successfully")
            } else {
                print("Failed to create table: \(db!.lastErrorMessage())")
            }
            
            db!.close()
        } else {
            print("Unable to open database")
        }
    }

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
                    let profileImageData = results.data(forColumn: "profileImage") // Fetch the profile image data
                    user = User(
                        firstName: results.string(forColumn: "firstName") ?? "",
                        lastName: results.string(forColumn: "lastName"),
                        email: results.string(forColumn: "email") ?? "",
                        contactNumber: results.string(forColumn: "contactNumber"),
                        password: results.string(forColumn: "password") ?? "",
                        dateOfBirth: results.string(forColumn: "dateOfBirth"),
                        gender: results.string(forColumn: "gender") ?? "",
                        country: results.string(forColumn: "country"),
                        profileImage: profileImageData,
                        termsAccepted: results.bool(forColumn: "termsAccepted")// Assign the profile image data
                    )
                }
            } catch {
                print("Failed to fetch user: \(error.localizedDescription)")
            }
            db!.close()
        }
        return user
    }

    func updatePassword(forUserWithEmail email: String, newPassword: String) -> Bool {
        if db!.open() {
            let updateQuery = "UPDATE Users SET password = ? WHERE email = ?"
            
            do {
                try db!.executeUpdate(updateQuery, values: [newPassword, email])
                print("Password updated successfully")
                db!.close()
                return true
            } catch {
                print("Failed to update password: \(error.localizedDescription)")
                db!.close()
                return false
            }
        } else {
            print("Unable to open database")
            return false
        }
    }

    func updateUserProfile(user: User, forEmail email: String) -> Bool {
        print("Updating user profile for email: \(email)")
        print("User details: \(user)")
        
        if db!.open() {
            let updateQuery = """
            UPDATE Users 
            SET firstName = ?, lastName = ?, contactNumber = ?, dateOfBirth = ?, gender = ?, country = ?, password = ?, profileImage = ? 
            WHERE email = ?;
            """
            
            do {
                try db!.executeUpdate(updateQuery, values: [
                    user.firstName,
                    user.lastName ?? "",
                    user.contactNumber ?? "",
                    user.dateOfBirth ?? "",
                    user.gender,
                    user.country ?? "",
                    user.password ?? "", // Include the password if it's not nil
                    user.profileImage as Any, // Include the profile image data
                    email
                ])
                print("User profile updated successfully")
                db!.close()
                return true
            } catch {
                print("Failed to update user profile: \(error.localizedDescription)")
                db!.close()
                return false
            }
        } else {
            print("Unable to open database")
            return false
        }
    }

    func updateUserProfileWithoutPassword(user: User, forEmail email: String) -> Bool {
        if db!.open() {
            let updateQuery = """
            UPDATE Users 
            SET firstName = ?, lastName = ?, contactNumber = ?, dateOfBirth = ?, gender = ?, country = ?, profileImage = ?
            WHERE email = ?;
            """
            
            do {
                try db!.executeUpdate(updateQuery, values: [
                    user.firstName,
                    user.lastName ?? "",
                    user.contactNumber ?? "",
                    user.dateOfBirth ?? "",
                    user.gender,
                    user.country ?? "",
                    user.profileImage as Any, // Include the profile image data
                    email
                ])
                print("User profile updated without changing password successfully")
                db!.close()
                return true
            } catch {
                print("Failed to update user profile: \(error.localizedDescription)")
                db!.close()
                return false
            }
        } else {
            print("Unable to open database")
            return false
        }
    }
}

struct User {
    let firstName: String
    let lastName: String?
    let email: String
    let contactNumber: String?
    let password: String?
    let dateOfBirth: String?
    let gender: String
    let country: String?
    let profileImage: Data? // Store image data
    let termsAccepted: Bool
}

