import Principal "mo:base/Principal";

module {

   // Bind select methods from the
   // system ManagementCanister at the well-known address 
   let ic00 = actor "aaaaa-aa" : actor {
     stop : Principal -> async ();
     delete : Principal -> async ();
   };
    
   // Destroy a canister (and burn its cycles)
   public func destroy(a : actor {}) : async () {
     let p = Principal.fromActor(a);
     ignore ic00.stop(p);
     ignore ic00.delete(p);
   };

}