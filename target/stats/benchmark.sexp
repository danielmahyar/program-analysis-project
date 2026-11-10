(benchmark
  :"jpamb.cases.Arrays.arrayContent!()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayContent:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 39 40)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Arrays.arrayContentAboveMinus13!()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayContentAboveMinus13:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 40 41 42)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arrayInBounds!()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayInBounds:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arrayIsNull!()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayIsNull:()V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("null pointer")
  )
  :"jpamb.cases.Arrays.arrayIsNullLength!()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayIsNullLength:()V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("null pointer")
  )
  :"jpamb.cases.Arrays.arrayLength!()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayLength:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 21)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arrayNotEmpty!([I:1])V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayNotEmpty:([I)V" (coverage
        :reachable (0 1 2 3 4 9)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arrayNotEmpty!([I:])V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayNotEmpty:([I)V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Arrays.arrayOutOfBounds!()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayOutOfBounds:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)
      )
    )
    :results ("out of bounds")
  )
  :"jpamb.cases.Arrays.arraySometimesNull!(0)V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySometimesNull:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
      )
    )
    :results ("out of bounds")
  )
  :"jpamb.cases.Arrays.arraySometimesNull!(11)V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySometimesNull:(I)V" (coverage
        :reachable (0 1 2 3 4 12 13 14 15)
      )
    )
    :results ("null pointer")
  )
  :"jpamb.cases.Arrays.arraySpellsHello!([C:'h', 'e', 'l', 'l', 'o'])V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySpellsHello:([C)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 31)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arraySpellsHello!([C:'x'])V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySpellsHello:([C)V" (coverage
        :reachable (0 1 2 3 4 5 6 27)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Arrays.arraySpellsHello!([C:])V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySpellsHello:([C)V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("out of bounds")
  )
  :"jpamb.cases.Arrays.arraySumIsLarge!([I:50, 100, 200])V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySumIsLarge:([I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 25)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arraySumIsLarge!([I:])V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySumIsLarge:([I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 16 17 18 19 20 21)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Arrays.binarySearch!(3)V" (control
    :coverage (
      :"jpamb.cases.Arrays.binarySearch:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.binarySearch!(6)V" (control
    :coverage (
      :"jpamb.cases.Arrays.binarySearch:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Calls.allPrimesArePositive!(-1)V" (control
    :coverage (
      :"jpamb.cases.Calls.allPrimesArePositive:(I)V" (coverage
        :reachable (0 1)
      )
      :"jpamb.cases.Calls.generatePrimeArray:(I)[I" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Calls.allPrimesArePositive!(0)V" (control
    :coverage (
      :"jpamb.cases.Calls.allPrimesArePositive:(I)V" (coverage
        :reachable (0 1)
      )
      :"jpamb.cases.Calls.generatePrimeArray:(I)[I" (coverage
        :reachable (0 1 2 3 8 9 10 11 12 13 14)
      )
    )
    :results ("out of bounds")
  )
  :"jpamb.cases.Calls.allPrimesArePositive!(100)V" (control
    :coverage (
      :"jpamb.cases.Calls.allPrimesArePositive:(I)V" (coverage
        :reachable (0 1)
      )
      :"jpamb.cases.Calls.generatePrimeArray:(I)[I" (coverage
        :reachable (0 1 2 3 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 56 57 58 59 60 61 62 63 64)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Calls.callsAssertFalse!()V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertFalse:()V" (coverage
        :reachable (0)
      )
      :"jpamb.cases.Calls.assertFalse:()V" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Calls.callsAssertFib!(0)V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertFib:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6)
      )
      :"jpamb.cases.Calls.fib:(I)I" (coverage
        :reachable (0 1 2 3 8 9 13 14)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Calls.callsAssertFib!(8)V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertFib:(I)V" (coverage
        :reachable (0 1 2 3)
      )
      :"jpamb.cases.Calls.fib:(I)I" (coverage
        :reachable (0 1 2 3 8 9 10 11 12 15 16 17 18)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Calls.callsAssertIf!(false)V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertIf:(Z)V" (coverage
        :reachable (0 1)
      )
      :"jpamb.cases.Calls.assertIf:(Z)V" (coverage
        :reachable (0 1 4)
      )
      :"jpamb.cases.Calls.assertFalse:()V" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Calls.callsAssertIf!(true)V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertIf:(Z)V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Calls.assertIf:(Z)V" (coverage
        :reachable (0 1 2 3 5)
      )
      :"jpamb.cases.Calls.assertTrue:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Calls.callsAssertIfWithTrue!()V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertIfWithTrue:()V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Calls.assertIf:(Z)V" (coverage
        :reachable (0 1 2 3 5)
      )
      :"jpamb.cases.Calls.assertTrue:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Calls.callsAssertTrue!()V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertTrue:()V" (coverage
        :reachable (0 1)
      )
      :"jpamb.cases.Calls.assertTrue:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.flowDownOneLevel!(1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.flowDownOneLevel:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.flowUpTwoLevels!(1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.flowUpTwoLevels:(I)V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Clearance.secretChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.joinBecomesSecret!(1, 2)V" (control
    :coverage (
      :"jpamb.cases.Clearance.joinBecomesSecret:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.joinStaysConfidential!(1, 2)V" (control
    :coverage (
      :"jpamb.cases.Clearance.joinStaysConfidential:(II)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.nestedBranches!(-1, 1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.nestedBranches:(II)V" (coverage
        :reachable (0 1 2 3 11 12 13)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.nestedBranches!(1, -1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.nestedBranches:(II)V" (coverage
        :reachable (0 1 2 3 4 5 9 10 11 12)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.nestedBranches!(1, 1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.nestedBranches:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 11 12)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.partnerCommand!(1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.partnerCommand:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.partnerToPartnerFeed!(1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.partnerToPartnerFeed:(I)V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Clearance.partnerFeed:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.secretBranchInLoop!(0, 5)V" (control
    :coverage (
      :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 19 20 21)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.secretBranchInLoop!(3, -1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 14 15 16 17 18 19 20 21)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.secretBranchInLoop!(3, 5)V" (control
    :coverage (
      :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.sequentialBranches!(-1, -1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.sequentialBranches:(II)V" (coverage
        :reachable (0 1 2 3 6 7 8 9 12 13 14)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.sequentialBranches!(1, 1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.sequentialBranches:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.topSecretBroadcast!(1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.topSecretBroadcast:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.trustedCommand!(1, 2)V" (control
    :coverage (
      :"jpamb.cases.Clearance.trustedCommand:(II)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.Clearance.commandSystem:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.untrustedToPartnerFeed!(1)V" (control
    :coverage (
      :"jpamb.cases.Clearance.untrustedToPartnerFeed:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.explicitDominatesImplicit!(-1, 5)V" (control
    :coverage (
      :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" (coverage
        :reachable (0 1 2 3 6 7 8)
      )
      :"jpamb.cases.Compartments.alphaBravoSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.explicitDominatesImplicit!(1, 5)V" (control
    :coverage (
      :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.implicitOutsideSink!(-1, 5)V" (control
    :coverage (
      :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" (coverage
        :reachable (0 1 2 3 6 7 8)
      )
      :"jpamb.cases.Compartments.bravoCharlieSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.implicitOutsideSink!(1, 5)V" (control
    :coverage (
      :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.implicitWithinSink!(-1, 5)V" (control
    :coverage (
      :"jpamb.cases.Compartments.implicitWithinSink:(II)V" (coverage
        :reachable (0 1 2 3 6 7 8)
      )
      :"jpamb.cases.Compartments.alphaCharlieSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.implicitWithinSink!(1, 5)V" (control
    :coverage (
      :"jpamb.cases.Compartments.implicitWithinSink:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
      :"jpamb.cases.Compartments.alphaCharlieSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.incomparableSink!(1)V" (control
    :coverage (
      :"jpamb.cases.Compartments.incomparableSink:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.joinIsLeastUpperBound!(1, 2)V" (control
    :coverage (
      :"jpamb.cases.Compartments.joinIsLeastUpperBound:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.joinOfThree!(1, 2, 3)V" (control
    :coverage (
      :"jpamb.cases.Compartments.joinOfThree:(III)V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.joinOfThreeToTop!(1, 2, 3)V" (control
    :coverage (
      :"jpamb.cases.Compartments.joinOfThreeToTop:(III)V" (coverage
        :reachable (0 1 2 3 4 5 6)
      )
      :"jpamb.cases.Compartments.allSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.joinOfTwo!(1, 2)V" (control
    :coverage (
      :"jpamb.cases.Compartments.joinOfTwo:(II)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.Compartments.alphaBravoSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.loopGuardAddsCompartment!(0, 4)V" (control
    :coverage (
      :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 16 17 18)
      )
      :"jpamb.cases.Compartments.alphaCharlieSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.loopGuardAddsCompartment!(2, 4)V" (control
    :coverage (
      :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Dependent.badNormalizedDistance!(0, 0)I" (control
    :coverage (
      :"jpamb.cases.Dependent.badNormalizedDistance:(II)I" (coverage
        :reachable (0 1 2 3 4 5 9 10 14 15 16 17 18 19)
      )
    )
    :results ("divide by zero")
  )
  :"jpamb.cases.Dependent.badNormalizedDistance!(1, 1)I" (control
    :coverage (
      :"jpamb.cases.Dependent.badNormalizedDistance:(II)I" (coverage
        :reachable (0 1 2 3 4 5 9 10 14 15 16 17 18 19 20)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Dependent.divisionLoop!(0)V" (control
    :coverage (
      :"jpamb.cases.Dependent.divisionLoop:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Dependent.divisionLoop!(1024)V" (control
    :coverage (
      :"jpamb.cases.Dependent.divisionLoop:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Dependent.normalizedDistance!(0, 0)I" (control
    :coverage (
      :"jpamb.cases.Dependent.normalizedDistance:(II)I" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Dependent.safeDivByN!(0)I" (control
    :coverage (
      :"jpamb.cases.Dependent.safeDivByN:(I)I" (coverage
        :reachable (0 1 6 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.adminCombinesDepartments!(10, 20)V" (control
    :coverage (
      :"jpamb.cases.Hospital.adminCombinesDepartments:(II)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.Hospital.adminReport:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.approveBilling!(150, 3)V" (control
    :coverage (
      :"jpamb.cases.Hospital.approveBilling:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 9 10 11)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.approveBilling!(50, 3)V" (control
    :coverage (
      :"jpamb.cases.Hospital.approveBilling:(II)V" (coverage
        :reachable (0 1 2 8 9 10 11)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.approveBillingTrusted!(3)V" (control
    :coverage (
      :"jpamb.cases.Hospital.approveBillingTrusted:(I)V" (coverage
        :reachable (0 1 2 3 4 6 7 8 9)
      )
      :"jpamb.cases.Hospital.billing:(Z)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.combinedToOneDepartment!(10, 20)V" (control
    :coverage (
      :"jpamb.cases.Hospital.combinedToOneDepartment:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.compartmentLeak!(4)V" (control
    :coverage (
      :"jpamb.cases.Hospital.compartmentLeak:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.deadBranchLeak!(7000)V" (control
    :coverage (
      :"jpamb.cases.Hospital.deadBranchLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.implicitCompartmentLeak!(10)V" (control
    :coverage (
      :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 7 8 9)
      )
      :"jpamb.cases.Hospital.oncologyRecords:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.implicitCompartmentLeak!(40)V" (control
    :coverage (
      :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.oncologyOnly!(25, 70)V" (control
    :coverage (
      :"jpamb.cases.Hospital.oncologyOnly:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18)
      )
      :"jpamb.cases.Hospital.oncologyRecords:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.oncologyOnly!(5, 30)V" (control
    :coverage (
      :"jpamb.cases.Hospital.oncologyOnly:(II)V" (coverage
        :reachable (0 1 2 3 4 9 10 11 16 17 18)
      )
      :"jpamb.cases.Hospital.oncologyRecords:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.process!(0, 0)V" (control
    :coverage (
      :"jpamb.cases.Hospital.process:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.process!(6000, 1)V" (control
    :coverage (
      :"jpamb.cases.Hospital.process:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.psychSessionCount!(0)V" (control
    :coverage (
      :"jpamb.cases.Hospital.psychSessionCount:(I)V" (coverage
        :reachable (0 1 2 3 4 5 15 16 17)
      )
      :"jpamb.cases.Hospital.publicDashboard:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.psychSessionCount!(3)V" (control
    :coverage (
      :"jpamb.cases.Hospital.psychSessionCount:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.publicRiskScore!(35)I" (control
    :coverage (
      :"jpamb.cases.Hospital.publicRiskScore:(I)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.sameValueBothBranches!(-1)V" (control
    :coverage (
      :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" (coverage
        :reachable (0 1 5 6 7 8)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.sameValueBothBranches!(1)V" (control
    :coverage (
      :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" (coverage
        :reachable (0 1 2 3 4 7 8)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.trustedAudit!(0)V" (control
    :coverage (
      :"jpamb.cases.Hospital.trustedAudit:(I)V" (coverage
        :reachable (0 1 2 3 4 12)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.trustedAudit!(3)V" (control
    :coverage (
      :"jpamb.cases.Hospital.trustedAudit:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12)
      )
      :"jpamb.cases.Hospital.auditLog:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.trustedButSecret!(9)V" (control
    :coverage (
      :"jpamb.cases.Hospital.trustedButSecret:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.untrustedControlsAudit!(false)V" (control
    :coverage (
      :"jpamb.cases.Hospital.untrustedControlsAudit:(Z)V" (coverage
        :reachable (0 1 4)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.untrustedControlsAudit!(true)V" (control
    :coverage (
      :"jpamb.cases.Hospital.untrustedControlsAudit:(Z)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.deadBranchLeak!(0)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.deadBranchLeak!(7)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.explicitLeak!(0)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.explicitLeak:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.explicitLeak!(42)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.explicitLeak:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.explicitSafe!(0)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.explicitSafe:(I)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.explicitSafe!(42)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.explicitSafe:(I)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.implicitLeak!(false)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" (coverage
        :reachable (0 1 2 3 6 7 8)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.implicitLeak!(true)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.implicitReturn!(-5)I" (control
    :coverage (
      :"jpamb.cases.InfoFlow.implicitReturn:(I)I" (coverage
        :reachable (0 1 4 5)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.implicitReturn!(5)I" (control
    :coverage (
      :"jpamb.cases.InfoFlow.implicitReturn:(I)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.integrityExplicit!(1)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.integrityExplicit:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.integrityImplicit!(false)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.integrityImplicit:(Z)V" (coverage
        :reachable (0 1 2 3 6 7 8)
      )
      :"jpamb.cases.InfoFlow.writeTrusted:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.integrityImplicit!(true)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.integrityImplicit:(Z)V" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.integritySafe!(1)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.integritySafe:(I)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.InfoFlow.writeTrusted:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.launderedThroughArithmetic!(0)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.launderedThroughArithmetic!(42)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.loopCountLeak!(0)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 5 15 16 17)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.loopCountLeak!(3)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.loopThenConstant!(0)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" (coverage
        :reachable (0 1 2 3 9 10 11)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.loopThenConstant!(3)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.overwrittenBeforeSink!(0)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.overwrittenBeforeSink!(42)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.pcRestoredAfterBranch!(-5)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" (coverage
        :reachable (0 1 2 3 6 7 8 9 10)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.pcRestoredAfterBranch!(5)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.sinkUnderSecretBranch!(false)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" (coverage
        :reachable (0 1 4)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.sinkUnderSecretBranch!(true)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.unannotatedInput!(1)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.unannotatedInput:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InformationFlow.compartmentLeak!(25, 10, 20)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.compartmentLeak:(III)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 13)
      )
      :"jpamb.cases.InformationFlow.oncologyRisk:(II)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 16 17)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InformationFlow.compartmentLeak!(25, 10, 40)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.compartmentLeak:(III)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9)
      )
      :"jpamb.cases.InformationFlow.oncologyRisk:(II)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InformationFlow.compartmentLeak!(25, 40, 50)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.compartmentLeak:(III)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 13)
      )
      :"jpamb.cases.InformationFlow.oncologyRisk:(II)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InformationFlow.explicitLeak!(4200, 1300)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.explicitLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
      :"jpamb.cases.InformationFlow.dashboard:(I)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InformationFlow.explicitLeak!(4200, 4900)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.explicitLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 11)
      )
      :"jpamb.cases.InformationFlow.dashboard:(I)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InformationFlow.implicitBranchLeak!(100, 200)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.implicitBranchLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 11)
      )
      :"jpamb.cases.InformationFlow.alertFlag:(I)I" (coverage
        :reachable (0 1 2 3 4 7 8)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InformationFlow.implicitBranchLeak!(6000, 0)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.implicitBranchLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
      :"jpamb.cases.InformationFlow.alertFlag:(I)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InformationFlow.implicitBranchLeak!(6000, 7000)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.implicitBranchLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 11)
      )
      :"jpamb.cases.InformationFlow.alertFlag:(I)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InformationFlow.implicitLoopLeak!(-1, -4)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.implicitLoopLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 11)
      )
      :"jpamb.cases.InformationFlow.sessionCount:(I)I" (coverage
        :reachable (0 1 2 3 4 5 15 16)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InformationFlow.implicitLoopLeak!(3, 3)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.implicitLoopLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 11)
      )
      :"jpamb.cases.InformationFlow.sessionCount:(I)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InformationFlow.implicitLoopLeak!(3, 5)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.implicitLoopLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5)
      )
      :"jpamb.cases.InformationFlow.sessionCount:(I)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InformationFlow.integrityViolation!(0, false, false)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.integrityViolation:(IZZ)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 13)
      )
      :"jpamb.cases.InformationFlow.auditCounter:(IZ)I" (coverage
        :reachable (0 1 2 3 4 5 6 16 17 22 23)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InformationFlow.integrityViolation!(3, true, false)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.integrityViolation:(IZZ)V" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
      :"jpamb.cases.InformationFlow.auditCounter:(IZ)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InformationFlow.integrityViolation!(3, true, true)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.integrityViolation:(IZZ)V" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
      :"jpamb.cases.InformationFlow.auditCounter:(IZ)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Loops.forever!()V" (control
    :coverage (
      :"jpamb.cases.Loops.forever:()V" (coverage
        :reachable (0)
      )
    )
    :results (*)
  )
  :"jpamb.cases.Loops.neverAsserts!()V" (control
    :coverage (
      :"jpamb.cases.Loops.neverAsserts:()V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results (*)
  )
  :"jpamb.cases.Loops.neverDivides!()I" (control
    :coverage (
      :"jpamb.cases.Loops.neverDivides:()I" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results (*)
  )
  :"jpamb.cases.Loops.terminates!()V" (control
    :coverage (
      :"jpamb.cases.Loops.terminates:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 10 11 12)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.assertBoolean!(false)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertBoolean:(Z)V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.assertBoolean!(true)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertBoolean:(Z)V" (coverage
        :reachable (0 1 2 3 8)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.assertFalse!()V" (control
    :coverage (
      :"jpamb.cases.Simple.assertFalse:()V" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.assertInteger!(0)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertInteger:(I)V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.assertInteger!(1)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertInteger:(I)V" (coverage
        :reachable (0 1 2 3 8)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.assertPositive!(-1)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertPositive:(I)V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.assertPositive!(1)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertPositive:(I)V" (coverage
        :reachable (0 1 2 3 8)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.assertTrue!()V" (control
    :coverage (
      :"jpamb.cases.Simple.assertTrue:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.checkBeforeAssert!(-1)V" (control
    :coverage (
      :"jpamb.cases.Simple.checkBeforeAssert:(I)V" (coverage
        :reachable (0 1 3 4 5 6 7 8 9)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.checkBeforeAssert!(0)V" (control
    :coverage (
      :"jpamb.cases.Simple.checkBeforeAssert:(I)V" (coverage
        :reachable (0 1 2)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.checkBeforeDivideByN2!(0)I" (control
    :coverage (
      :"jpamb.cases.Simple.checkBeforeDivideByN2:(I)I" (coverage
        :reachable (0 1 6 7 8 9 10 15 16)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.checkBeforeDivideByN!(0)I" (control
    :coverage (
      :"jpamb.cases.Simple.checkBeforeDivideByN:(I)I" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.checkBeforeDivideByN!(1)I" (control
    :coverage (
      :"jpamb.cases.Simple.checkBeforeDivideByN:(I)I" (coverage
        :reachable (0 1 2 3 8 9 10 11)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.divideByN!(0)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideByN:(I)I" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("divide by zero")
  )
  :"jpamb.cases.Simple.divideByN!(1)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideByN:(I)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.divideByNMinus10054203!(0)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideByNMinus10054203:(I)I" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.divideByNMinus10054203!(10054203)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideByNMinus10054203:(I)I" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("divide by zero")
  )
  :"jpamb.cases.Simple.divideByZero!()I" (control
    :coverage (
      :"jpamb.cases.Simple.divideByZero:()I" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("divide by zero")
  )
  :"jpamb.cases.Simple.divideZeroByZero!(0, 0)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideZeroByZero:(II)I" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("divide by zero")
  )
  :"jpamb.cases.Simple.divideZeroByZero!(0, 1)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideZeroByZero:(II)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.doNothing!()V" (control
    :coverage (
      :"jpamb.cases.Simple.doNothing:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.earlyReturn!()I" (control
    :coverage (
      :"jpamb.cases.Simple.earlyReturn:()I" (coverage
        :reachable (0 1)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.justAdd!(1, 2)I" (control
    :coverage (
      :"jpamb.cases.Simple.justAdd:(II)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.justMulitply!(1, 2)I" (control
    :coverage (
      :"jpamb.cases.Simple.justMulitply:(II)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.justReturn!()I" (control
    :coverage (
      :"jpamb.cases.Simple.justReturn:()I" (coverage
        :reachable (0 1)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.justReturnNothing!()V" (control
    :coverage (
      :"jpamb.cases.Simple.justReturnNothing:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.multiError!(false)I" (control
    :coverage (
      :"jpamb.cases.Simple.multiError:(Z)I" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.multiError!(true)I" (control
    :coverage (
      :"jpamb.cases.Simple.multiError:(Z)I" (coverage
        :reachable (0 1 2 3 8 9 10)
      )
    )
    :results ("divide by zero")
  )
  :"jpamb.cases.Strings.sayHello!(s'hello')V" (control
    :coverage (
      :"jpamb.cases.Strings.sayHello:(Ljava/lang/String;)V" (coverage
        :reachable (0 1 2 3 4 5 10)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Strings.sayHello!(s'not hello')V" (control
    :coverage (
      :"jpamb.cases.Strings.sayHello:(Ljava/lang/String;)V" (coverage
        :reachable (0 1 2 3 4 5 6)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Tricky.collatz!(0)V" (control
    :coverage (
      :"jpamb.cases.Tricky.collatz:(I)V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Tricky.collatz!(24)V" (control
    :coverage (
      :"jpamb.cases.Tricky.collatz:(I)V" (coverage
        :reachable (0 1 2 3 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arrayContent:()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayContent:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 39 40)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Arrays.arrayContentAboveMinus13:()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayContentAboveMinus13:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 40 41 42)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arrayInBounds:()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayInBounds:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arrayIsNull:()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayIsNull:()V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("null pointer")
  )
  :"jpamb.cases.Arrays.arrayIsNullLength:()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayIsNullLength:()V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("null pointer")
  )
  :"jpamb.cases.Arrays.arrayLength:()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayLength:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 21)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Arrays.arrayNotEmpty:([I)V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayNotEmpty:([I)V" (coverage
        :reachable (0 1 2 3 4 5 9)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Arrays.arrayOutOfBounds:()V" (control
    :coverage (
      :"jpamb.cases.Arrays.arrayOutOfBounds:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)
      )
    )
    :results ("out of bounds")
  )
  :"jpamb.cases.Arrays.arraySometimesNull:(I)V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySometimesNull:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
      )
    )
    :results ("null pointer" "out of bounds")
  )
  :"jpamb.cases.Arrays.arraySpellsHello:([C)V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySpellsHello:([C)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 31)
      )
    )
    :results ("assertion error" ok "out of bounds")
  )
  :"jpamb.cases.Arrays.arraySumIsLarge:([I)V" (control
    :coverage (
      :"jpamb.cases.Arrays.arraySumIsLarge:([I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 25)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Arrays.binarySearch:(I)V" (control
    :coverage (
      :"jpamb.cases.Arrays.binarySearch:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Calls.allPrimesArePositive:(I)V" (control
    :coverage (
      :"jpamb.cases.Calls.allPrimesArePositive:(I)V" (coverage
        :reachable (0 1)
      )
      :"jpamb.cases.Calls.generatePrimeArray:(I)[I" (coverage
        :reachable (0 1 2 3 4 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 56 57 58 59 60 61 62 63 64)
      )
    )
    :results ("assertion error" ok "out of bounds")
  )
  :"jpamb.cases.Calls.callsAssertFalse:()V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertFalse:()V" (coverage
        :reachable (0)
      )
      :"jpamb.cases.Calls.assertFalse:()V" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Calls.callsAssertFib:(I)V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertFib:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6)
      )
      :"jpamb.cases.Calls.fib:(I)I" (coverage
        :reachable (0 1 2 3 8 9 10 11 12 13 14 15 16 17 18)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Calls.callsAssertIf:(Z)V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertIf:(Z)V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Calls.assertIf:(Z)V" (coverage
        :reachable (0 1 2 3 4 5)
      )
      :"jpamb.cases.Calls.assertFalse:()V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Calls.assertTrue:()V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Calls.callsAssertIfWithTrue:()V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertIfWithTrue:()V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Calls.assertIf:(Z)V" (coverage
        :reachable (0 1 2 3 5)
      )
      :"jpamb.cases.Calls.assertTrue:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Calls.callsAssertTrue:()V" (control
    :coverage (
      :"jpamb.cases.Calls.callsAssertTrue:()V" (coverage
        :reachable (0 1)
      )
      :"jpamb.cases.Calls.assertTrue:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.flowDownOneLevel:(I)V" (control
    :coverage (
      :"jpamb.cases.Clearance.flowDownOneLevel:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.flowUpTwoLevels:(I)V" (control
    :coverage (
      :"jpamb.cases.Clearance.flowUpTwoLevels:(I)V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Clearance.secretChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.joinBecomesSecret:(II)V" (control
    :coverage (
      :"jpamb.cases.Clearance.joinBecomesSecret:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.joinStaysConfidential:(II)V" (control
    :coverage (
      :"jpamb.cases.Clearance.joinStaysConfidential:(II)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.nestedBranches:(II)V" (control
    :coverage (
      :"jpamb.cases.Clearance.nestedBranches:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Clearance.partnerCommand:(I)V" (control
    :coverage (
      :"jpamb.cases.Clearance.partnerCommand:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.partnerToPartnerFeed:(I)V" (control
    :coverage (
      :"jpamb.cases.Clearance.partnerToPartnerFeed:(I)V" (coverage
        :reachable (0 1 2)
      )
      :"jpamb.cases.Clearance.partnerFeed:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" (control
    :coverage (
      :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Clearance.sequentialBranches:(II)V" (control
    :coverage (
      :"jpamb.cases.Clearance.sequentialBranches:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)
      )
      :"jpamb.cases.Clearance.confidentialChannel:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.topSecretBroadcast:(I)V" (control
    :coverage (
      :"jpamb.cases.Clearance.topSecretBroadcast:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Clearance.trustedCommand:(II)V" (control
    :coverage (
      :"jpamb.cases.Clearance.trustedCommand:(II)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.Clearance.commandSystem:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Clearance.untrustedToPartnerFeed:(I)V" (control
    :coverage (
      :"jpamb.cases.Clearance.untrustedToPartnerFeed:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" (control
    :coverage (
      :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
      :"jpamb.cases.Compartments.alphaBravoSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" (control
    :coverage (
      :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
      :"jpamb.cases.Compartments.bravoCharlieSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Compartments.implicitWithinSink:(II)V" (control
    :coverage (
      :"jpamb.cases.Compartments.implicitWithinSink:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
      :"jpamb.cases.Compartments.alphaCharlieSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.incomparableSink:(I)V" (control
    :coverage (
      :"jpamb.cases.Compartments.incomparableSink:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.joinIsLeastUpperBound:(II)V" (control
    :coverage (
      :"jpamb.cases.Compartments.joinIsLeastUpperBound:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.joinOfThree:(III)V" (control
    :coverage (
      :"jpamb.cases.Compartments.joinOfThree:(III)V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Compartments.joinOfThreeToTop:(III)V" (control
    :coverage (
      :"jpamb.cases.Compartments.joinOfThreeToTop:(III)V" (coverage
        :reachable (0 1 2 3 4 5 6)
      )
      :"jpamb.cases.Compartments.allSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.joinOfTwo:(II)V" (control
    :coverage (
      :"jpamb.cases.Compartments.joinOfTwo:(II)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.Compartments.alphaBravoSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" (control
    :coverage (
      :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18)
      )
      :"jpamb.cases.Compartments.alphaCharlieSink:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Dependent.badNormalizedDistance:(II)I" (control
    :coverage (
      :"jpamb.cases.Dependent.badNormalizedDistance:(II)I" (coverage
        :reachable (0 1 2 3 4 5 9 10 14 15 16 17 18 19 20)
      )
    )
    :results ("divide by zero" ok)
  )
  :"jpamb.cases.Dependent.divisionLoop:(I)V" (control
    :coverage (
      :"jpamb.cases.Dependent.divisionLoop:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 20)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Dependent.normalizedDistance:(II)I" (control
    :coverage (
      :"jpamb.cases.Dependent.normalizedDistance:(II)I" (coverage
        :reachable (0 1 2 3 4 5 6 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Dependent.safeDivByN:(I)I" (control
    :coverage (
      :"jpamb.cases.Dependent.safeDivByN:(I)I" (coverage
        :reachable (0 1 6 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.adminCombinesDepartments:(II)V" (control
    :coverage (
      :"jpamb.cases.Hospital.adminCombinesDepartments:(II)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.Hospital.adminReport:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.approveBilling:(II)V" (control
    :coverage (
      :"jpamb.cases.Hospital.approveBilling:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.approveBillingTrusted:(I)V" (control
    :coverage (
      :"jpamb.cases.Hospital.approveBillingTrusted:(I)V" (coverage
        :reachable (0 1 2 3 4 6 7 8 9)
      )
      :"jpamb.cases.Hospital.billing:(Z)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.combinedToOneDepartment:(II)V" (control
    :coverage (
      :"jpamb.cases.Hospital.combinedToOneDepartment:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.compartmentLeak:(I)V" (control
    :coverage (
      :"jpamb.cases.Hospital.compartmentLeak:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.deadBranchLeak:(I)V" (control
    :coverage (
      :"jpamb.cases.Hospital.deadBranchLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" (control
    :coverage (
      :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9)
      )
      :"jpamb.cases.Hospital.oncologyRecords:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Hospital.oncologyOnly:(II)V" (control
    :coverage (
      :"jpamb.cases.Hospital.oncologyOnly:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18)
      )
      :"jpamb.cases.Hospital.oncologyRecords:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.process:(II)V" (control
    :coverage (
      :"jpamb.cases.Hospital.process:(II)V" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.psychSessionCount:(I)V" (control
    :coverage (
      :"jpamb.cases.Hospital.psychSessionCount:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)
      )
      :"jpamb.cases.Hospital.publicDashboard:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Hospital.publicRiskScore:(I)I" (control
    :coverage (
      :"jpamb.cases.Hospital.publicRiskScore:(I)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" (control
    :coverage (
      :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.trustedAudit:(I)V" (control
    :coverage (
      :"jpamb.cases.Hospital.trustedAudit:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12)
      )
      :"jpamb.cases.Hospital.auditLog:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Hospital.trustedButSecret:(I)V" (control
    :coverage (
      :"jpamb.cases.Hospital.trustedButSecret:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Hospital.untrustedControlsAudit:(Z)V" (control
    :coverage (
      :"jpamb.cases.Hospital.untrustedControlsAudit:(Z)V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 7)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.explicitLeak:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.explicitLeak:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.explicitSafe:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.explicitSafe:(I)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InfoFlow.implicitReturn:(I)I" (control
    :coverage (
      :"jpamb.cases.InfoFlow.implicitReturn:(I)I" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.integrityExplicit:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.integrityExplicit:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.integrityImplicit:(Z)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.integrityImplicit:(Z)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
      :"jpamb.cases.InfoFlow.writeTrusted:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InfoFlow.integritySafe:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.integritySafe:(I)V" (coverage
        :reachable (0 1 2 3 4)
      )
      :"jpamb.cases.InfoFlow.writeTrusted:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10)
      )
      :"jpamb.cases.InfoFlow.publish:(I)V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InfoFlow.unannotatedInput:(I)V" (control
    :coverage (
      :"jpamb.cases.InfoFlow.unannotatedInput:(I)V" (coverage
        :reachable (0 1)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.InformationFlow.compartmentLeak:(III)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.compartmentLeak:(III)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 13)
      )
      :"jpamb.cases.InformationFlow.oncologyRisk:(II)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InformationFlow.explicitLeak:(II)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.explicitLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 11)
      )
      :"jpamb.cases.InformationFlow.dashboard:(I)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InformationFlow.implicitBranchLeak:(II)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.implicitBranchLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 11)
      )
      :"jpamb.cases.InformationFlow.alertFlag:(I)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InformationFlow.implicitLoopLeak:(II)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.implicitLoopLeak:(II)V" (coverage
        :reachable (0 1 2 3 4 5 6 11)
      )
      :"jpamb.cases.InformationFlow.sessionCount:(I)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.InformationFlow.integrityViolation:(IZZ)V" (control
    :coverage (
      :"jpamb.cases.InformationFlow.integrityViolation:(IZZ)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 13)
      )
      :"jpamb.cases.InformationFlow.auditCounter:(IZ)I" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Loops.forever:()V" (control
    :coverage (
      :"jpamb.cases.Loops.forever:()V" (coverage
        :reachable (0)
      )
    )
    :results (*)
  )
  :"jpamb.cases.Loops.neverAsserts:()V" (control
    :coverage (
      :"jpamb.cases.Loops.neverAsserts:()V" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results (*)
  )
  :"jpamb.cases.Loops.neverDivides:()I" (control
    :coverage (
      :"jpamb.cases.Loops.neverDivides:()I" (coverage
        :reachable (0 1 2 3 4)
      )
    )
    :results (*)
  )
  :"jpamb.cases.Loops.terminates:()V" (control
    :coverage (
      :"jpamb.cases.Loops.terminates:()V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 10 11 12)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.assertBoolean:(Z)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertBoolean:(Z)V" (coverage
        :reachable (0 1 2 3 4 8)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Simple.assertFalse:()V" (control
    :coverage (
      :"jpamb.cases.Simple.assertFalse:()V" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("assertion error")
  )
  :"jpamb.cases.Simple.assertInteger:(I)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertInteger:(I)V" (coverage
        :reachable (0 1 2 3 4 8)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Simple.assertPositive:(I)V" (control
    :coverage (
      :"jpamb.cases.Simple.assertPositive:(I)V" (coverage
        :reachable (0 1 2 3 4 8)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Simple.assertTrue:()V" (control
    :coverage (
      :"jpamb.cases.Simple.assertTrue:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.checkBeforeAssert:(I)V" (control
    :coverage (
      :"jpamb.cases.Simple.checkBeforeAssert:(I)V" (coverage
        :reachable (0 1 2 3 4 5 6 7 8 9)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Simple.checkBeforeDivideByN2:(I)I" (control
    :coverage (
      :"jpamb.cases.Simple.checkBeforeDivideByN2:(I)I" (coverage
        :reachable (0 1 6 7 8 9 10 15 16)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.checkBeforeDivideByN:(I)I" (control
    :coverage (
      :"jpamb.cases.Simple.checkBeforeDivideByN:(I)I" (coverage
        :reachable (0 1 2 3 4 8 9 10 11)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Simple.divideByN:(I)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideByN:(I)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("divide by zero" ok)
  )
  :"jpamb.cases.Simple.divideByNMinus10054203:(I)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideByNMinus10054203:(I)I" (coverage
        :reachable (0 1 2 3 4 5)
      )
    )
    :results ("divide by zero" ok)
  )
  :"jpamb.cases.Simple.divideByZero:()I" (control
    :coverage (
      :"jpamb.cases.Simple.divideByZero:()I" (coverage
        :reachable (0 1 2)
      )
    )
    :results ("divide by zero")
  )
  :"jpamb.cases.Simple.divideZeroByZero:(II)I" (control
    :coverage (
      :"jpamb.cases.Simple.divideZeroByZero:(II)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results ("divide by zero" ok)
  )
  :"jpamb.cases.Simple.doNothing:()V" (control
    :coverage (
      :"jpamb.cases.Simple.doNothing:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.earlyReturn:()I" (control
    :coverage (
      :"jpamb.cases.Simple.earlyReturn:()I" (coverage
        :reachable (0 1)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.justAdd:(II)I" (control
    :coverage (
      :"jpamb.cases.Simple.justAdd:(II)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.justMulitply:(II)I" (control
    :coverage (
      :"jpamb.cases.Simple.justMulitply:(II)I" (coverage
        :reachable (0 1 2 3)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.justReturn:()I" (control
    :coverage (
      :"jpamb.cases.Simple.justReturn:()I" (coverage
        :reachable (0 1)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.justReturnNothing:()V" (control
    :coverage (
      :"jpamb.cases.Simple.justReturnNothing:()V" (coverage
        :reachable (0)
      )
    )
    :results (ok)
  )
  :"jpamb.cases.Simple.multiError:(Z)I" (control
    :coverage (
      :"jpamb.cases.Simple.multiError:(Z)I" (coverage
        :reachable (0 1 2 3 4 8 9 10)
      )
    )
    :results ("assertion error" "divide by zero")
  )
  :"jpamb.cases.Strings.sayHello:(Ljava/lang/String;)V" (control
    :coverage (
      :"jpamb.cases.Strings.sayHello:(Ljava/lang/String;)V" (coverage
        :reachable (0 1 2 3 4 5 6 10)
      )
    )
    :results ("assertion error" ok)
  )
  :"jpamb.cases.Tricky.collatz:(I)V" (control
    :coverage (
      :"jpamb.cases.Tricky.collatz:(I)V" (coverage
        :reachable (0 1 2 3 4 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26)
      )
    )
    :results ("assertion error" ok)
  )
)