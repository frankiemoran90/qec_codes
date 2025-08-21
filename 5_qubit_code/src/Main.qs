namespace CheckEnv {
    import Std.Random.DrawRandomInt;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Random;

    operation encode_5(logicalQubit : Qubit[]) : Unit is Adj + Ctl {
        // From fig 15: https://shubhamchandak94.github.io/reports/stabilizer_code_report.pdf
        
        // Phase 1:
        H(logicalQubit[0]);
        S(logicalQubit[0]);
        Controlled Z([logicalQubit[0]], logicalQubit[1]);
        Controlled Z([logicalQubit[0]], logicalQubit[3]);        
        Controlled Y([logicalQubit[0]], logicalQubit[4]);

        // Phase 2:
        H(logicalQubit[1]);
        Controlled Z([logicalQubit[1]], logicalQubit[2]);
        Controlled Z([logicalQubit[1]], logicalQubit[3]);
        CNOT(logicalQubit[1], logicalQubit[4]);

        // Phase 3:
        H(logicalQubit[2]);
        Controlled Z([logicalQubit[2]], logicalQubit[0]);
        Controlled Z([logicalQubit[2]], logicalQubit[1]);
        CNOT(logicalQubit[2], logicalQubit[4]);

        // Phase 4:
        H(logicalQubit[3]);
        S(logicalQubit[3]);
        Controlled Z([logicalQubit[3]], logicalQubit[0]);
        Controlled Z([logicalQubit[3]], logicalQubit[2]);
        Controlled Y([logicalQubit[3]], logicalQubit[4]);
    }

    operation apply_stabilizers(data : Qubit[], ancilla : Qubit[]) : Unit is Adj + Ctl {

        H(ancilla[0]);
        H(ancilla[1]);
        H(ancilla[2]);
        H(ancilla[3]);

        // M0 ZXXZI
        Controlled Z([ancilla[3]], data[0]);
        Controlled X([ancilla[3]], data[1]);
        Controlled X([ancilla[3]], data[2]);
        Controlled Z([ancilla[3]], data[3]);
        
        // M1 XXZIZ
        Controlled X([ancilla[2]], data[0]);
        Controlled X([ancilla[2]], data[1]);
        Controlled Z([ancilla[2]], data[2]);
        Controlled Z([ancilla[2]], data[4]);

        // M2 XZIZX
        Controlled X([ancilla[1]], data[0]);
        Controlled Z([ancilla[1]], data[1]);
        Controlled Z([ancilla[1]], data[3]);
        Controlled X([ancilla[1]], data[4]);

        // M3 ZIZXX
        Controlled Z([ancilla[0]], data[0]);
        Controlled Z([ancilla[0]], data[2]);
        Controlled X([ancilla[0]], data[3]);
        Controlled X([ancilla[0]], data[4]);

        H(ancilla[0]);
        H(ancilla[1]);
        H(ancilla[2]);
        H(ancilla[3]);
    }
    @EntryPoint()


    operation Main() : Unit {
        Message("Target machine: QuantumSimulator");

        // Encoder - maps qubit a|0> + b|1> into a|0_L> + b|1_L>
        use data = Qubit();
        use d_ancilla = Qubit[4]; // Data ancilla, makes logical Qubit
        use s_ancilla = Qubit[4]; // Stabilizer Ancilla
        
        let logicalQubit = d_ancilla + [data];

        // Create Logical Qubit
        encode_5(logicalQubit);

        // Apply Stabilizers
        apply_stabilizers(logicalQubit, s_ancilla);

        // Measure stabilizer ancilla 
        let M1 = M(s_ancilla[0]);
        let M2 = M(s_ancilla[1]);
        let M3 = M(s_ancilla[2]);
        let M4 = M(s_ancilla[3]);

        Message($"M1 = {M1}");
        Message($"M2 = {M2}");
        Message($"M3 = {M3}");
        Message($"M4 = {M4}");


        ResetAll(d_ancilla + [data])
        
    }
}
