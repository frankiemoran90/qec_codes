namespace CheckEnv {
    import Std.Random.DrawRandomInt;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Random;

    @EntryPoint()
    operation Main() : Unit {
        Message("Target machine: QuantumSimulator");

        // Start by creating state a|000> + b|111>
        use psi = Qubit[3];
        
        //C-not gates
        CNOT(psi[0], psi[1]);
        CNOT(psi[0], psi[1]);
        
        // Add errors 
        let r = DrawRandomInt(0,3);
        
        if(r != 3){
            X(psi[r]); 
        }
        
        // Define our Check Qubits
        use check = Qubit[2];

        //CNOTs for parity check
        CNOT(psi[0], check[0]);
        CNOT(psi[1], check[0]);
        CNOT(psi[1], check[1]);
        CNOT(psi[2], check[1]);

        // Measure our checks for recovery
        let M1 = M(check[0]);
        let M2 = M(check[1]);

        if(M1 == One and M2 == One){
            Message("Error on Qubit 2, corrected");
            // Correct and return Qubits to original State
            X(psi[1]);
            X(check[0]);
            X(check[1]);
        }
        else{
            if(M1 == One){
                Message("Error on Qubit 1, corrected");
                X(psi[0]);
                X(check[0]);
            }
            if(M2 == One){
                Message("Error on Qubit 3, corrected");
                X(psi[2]);
                X(check[1]);
            }
        } 
    }
}
