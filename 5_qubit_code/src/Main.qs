namespace CheckEnv {
    import Std.Random.DrawRandomInt;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Random;

    operation encode_5(data : Qubit, ancilla : Qubit[]) : Unit is Adj + Ctl {
        // From fig 15: https://shubhamchandak94.github.io/reports/stabilizer_code_report.pdf
        
        // Phase 1:
        H(ancilla[0]);
        S(ancilla[0]);
        Controlled Z([ancilla[0]], ancilla[1]);
        Controlled Z([ancilla[0]], ancilla[3]);        
        Controlled Y([ancilla[0]], data);

        // Phase 2:
        H(ancilla[1]);
        Controlled Z([ancilla[1]], ancilla[2]);
        Controlled Z([ancilla[1]], ancilla[3]);
        CNOT(ancilla[1], data);

        // Phase 3:
        H(ancilla[2]);
        Controlled Z([ancilla[2]], ancilla[0]);
        Controlled Z([ancilla[2]], ancilla[1]);
        CNOT(ancilla[2], data);

        // Phase 4:
        H(ancilla[3]);
        S(ancilla[3]);
        Controlled Z([ancilla[3]], ancilla[0]);
        Controlled Z([ancilla[3]], ancilla[2]);
        Controlled Y([ancilla[3]], data);
    }

    @EntryPoint()


    operation Main() : Unit {
        Message("Target machine: QuantumSimulator");

        // Encoder - maps qubit a|0> + b|1> into a|0_L> + b|1_L>
        use data = Qubit();
        use ancilla = Qubit[4];
        
        encode_5(data, ancilla);

        ResetAll(ancilla + [data])
        
    }
}
