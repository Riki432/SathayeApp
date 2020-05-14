import * as functions from 'firebase-functions';
import admin = require('firebase-admin');
import { firestore} from 'firebase-admin';

admin.initializeApp();



/// This function gets triggered *whenever* a new document is created in the Admin's collection       
export const createAdmin = functions.firestore.document("Admins/{Admin}").onCreate((change, context)=>{
    // Get a reference to the Admin's collection 
    const ref = firestore().collection("Admins");
    
    // Get the data from the document that was just created.
    // If the Email or Password fields are empty then return
    ref.doc(context.params.Admin).get()
        .then((document) =>{
            const data = document.data()!;
            if(data["Email"] == undefined || data["Password"] == undefined){
                console.log("Email or Password were null");
                return;
            }
            const email     = data["Email"];
            const password  = data["Password"];
            const firstName = data["FirstName"];
            const lastName  = data["LastName"];

            // Create a new user with email and password from the original document
            admin.auth().createUser({
                email : email,
                password : password,
                displayName : firstName + " " + lastName,

            })
            .then((record) => {
                console.log(`Created a new admin ${firstName + " " + lastName}`);
                
                /// Create a new record with the uid of this new user in the Admin's collection
                /// This is so that whenever this user logs in we have their data by their UID.
                /// This will also trigger the current function but since this time password field isn't available
                /// The execution won't go into an infinite loop.
                ref.doc(record.uid).set({
                    "Email" : record.email,
                    "FirstName" : firstName,
                    "LastName" : lastName,
                })
                .then(() => {
                    /// Delete the original document.
                    ref.doc(context.params.Admin).delete()
                    .then(() => console.log("Deleted original record"))
                    .catch((err) => console.log(err));
                })
                .catch((err) => console.log(err));

            })
            .catch((err) => console.log(err));
        })
        .catch((err) => console.log(err));
});