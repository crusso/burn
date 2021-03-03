import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";

import Lib "Burner";

actor {

    public query func balance() : async Nat {
        Cycles.balance();
    };

    public func burn(amount : Nat) : async (Nat,Nat) {
        let pre = Cycles.balance();
        // instantiate an dummy actor, passing cycles
        Cycles.add(amount);
        ignore Lib.Burner();
        // works, but leaks the Burner instance on the network
        return (pre, Cycles.balance());
    };

    // Bind select methods from the
    // system ManagementCanister at the well-known address "aaaaa-aa"
    // (not documented publically yet)
    // used below to create, stop and delete canisters.
    let ic00 = actor "aaaaa-aa" : actor {
      create_canister : () -> async { canister_id : Principal };
      stop : Principal -> async ();
      delete : Principal -> async ();
    };
    
    // Like burn(), but stops and deletes the dummy actor instance
    public func burnBetter(amount : Nat) : async (Nat,Nat) {
        let pre = Cycles.balance();
        // instantiate Burner canister
        Cycles.add(amount);
        let burner = await Lib.Burner();
        let p = Principal.fromActor(burner);
        ignore ic00.stop(p);
        ignore ic00.delete(p);
        return (pre, Cycles.balance());
    };

    // Just creates and deletes an empty canister,
    // no actor class required
    public func burnBest(amount : Nat) : async (Nat,Nat) {
        let pre = Cycles.balance();
        // create an empty cansiter (sans code)
        Cycles.add(amount);
        let id = await ic00.create_canister();
        // delete it and its cycles
        ignore ic00.delete(id.canister_id);
        return (pre, Cycles.balance());
    };

};
