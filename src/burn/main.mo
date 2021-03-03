import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Canisters "Canisters";
import Lib "Burner";


actor {

    public query func balance() : async Nat {
        Cycles.balance();
    };

    public func burn(amount : Nat) : async (Nat,Nat) {
        let pre = Cycles.balance();
        Cycles.add(amount);
        let burner = await Lib.Burner();
        ignore Canisters.destroy(burner);
        return (pre, Cycles.balance());
    };

    public func burnFast(amount : Nat) : async (Nat,Nat) {
        let pre = Cycles.balance();
        Cycles.add(amount);
        ignore Lib.Burner();
        return (pre, Cycles.balance());
    };
};
