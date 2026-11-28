(analysis-summary
  :config (analysis-config
    :cmd (/Users/Bruger/Desktop/program-analysis-project/solutions/project-syntactic-confidentiality/.venv/bin/python /Users/Bruger/Desktop/program-analysis-project/solutions/project-syntactic-confidentiality/src/syntactic_confidentiality.py)
    :analysis (analysis-info
      :name project-syntactic-confidentiality
      :version 0.2.0
      :group LineaRIZZability
      :tags (syntactic python)
      :system macOS-15.6.1-arm64-arm-64bit-Mach-O
    )
    :experiments (
      :"jpamb.cases.AdvancedLeaks.computedDeadBranchSafe:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.continueSkipsSink:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.continueSkipsSinkSafe:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.doWhileLeak:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.earlyReturnBeforeSink:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.earlyReturnSafe:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.forLoopLeak:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.forLoopSafe:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.nestedThresholdLeak:(II)V" ()
      :"jpamb.cases.AdvancedLeaks.nestedWhileSafe:(III)V" ()
      :"jpamb.cases.AdvancedLeaks.nestedWhileWeirdCaseLeak:(III)V" ()
      :"jpamb.cases.AdvancedLeaks.overwrittenAfterBranchSafe:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.ternaryDeadBranchSafe:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.ternaryImplicitLeak:(I)V" ()
      :"jpamb.cases.AdvancedLeaks.tripleNestedWhileCornerLeak:(IIII)V" ()
      :"jpamb.cases.BasicLeaks.explicitArithmetic:(I)V" ()
      :"jpamb.cases.BasicLeaks.explicitConstantSafe:(I)V" ()
      :"jpamb.cases.BasicLeaks.explicitCopy:(I)V" ()
      :"jpamb.cases.BasicLeaks.explicitDirect:(I)V" ()
      :"jpamb.cases.BasicLeaks.explicitDirectSafe:(I)V" ()
      :"jpamb.cases.BasicLeaks.explicitMixed:(II)V" ()
      :"jpamb.cases.BasicLeaks.explicitMixedSafe:(II)V" ()
      :"jpamb.cases.BasicLeaks.explicitReturn:(I)I" ()
      :"jpamb.cases.BasicLeaks.explicitReturnSafe:(I)I" ()
      :"jpamb.cases.BasicLeaks.implicitAfterBranchSafe:(II)V" ()
      :"jpamb.cases.BasicLeaks.implicitIf:(I)V" ()
      :"jpamb.cases.BasicLeaks.implicitIfElse:(I)V" ()
      :"jpamb.cases.BasicLeaks.implicitIfSafe:(I)V" ()
      :"jpamb.cases.BasicLeaks.implicitReturn:(I)I" ()
      :"jpamb.cases.BasicLeaks.implicitSinkInBranch:(I)V" ()
      :"jpamb.cases.BasicLeaks.implicitWhile:(I)V" ()
      :"jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V" ()
      :"jpamb.cases.BasicLeaks.skippedLoop:(I)V" ()
      :"jpamb.cases.BasicLeaks.staticFlagsButDynamicDoesnt:(I)V" ()
      :"jpamb.cases.Clearance.flowDownOneLevel:(I)V" ()
      :"jpamb.cases.Clearance.flowUpTwoLevels:(I)V" ()
      :"jpamb.cases.Clearance.joinBecomesSecret:(II)V" ()
      :"jpamb.cases.Clearance.joinStaysConfidential:(II)V" ()
      :"jpamb.cases.Clearance.nestedBranches:(II)V" ()
      :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" ()
      :"jpamb.cases.Clearance.sequentialBranches:(II)V" ()
      :"jpamb.cases.Clearance.topSecretBroadcast:(I)V" ()
      :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" ()
      :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" ()
      :"jpamb.cases.Compartments.implicitWithinSink:(II)V" ()
      :"jpamb.cases.Compartments.incomparableSink:(I)V" ()
      :"jpamb.cases.Compartments.joinIsLeastUpperBound:(II)V" ()
      :"jpamb.cases.Compartments.joinOfThree:(III)V" ()
      :"jpamb.cases.Compartments.joinOfThreeToTop:(III)V" ()
      :"jpamb.cases.Compartments.joinOfTwo:(II)V" ()
      :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.neutralTarget19:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.neutralTarget23:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.neutralTarget31:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.neutralTargetSafe:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.opaquePair17:(III)V" ()
      :"jpamb.cases.FuzzingChallenges.opaquePair29:(III)V" ()
      :"jpamb.cases.FuzzingChallenges.opaquePair53:(III)V" ()
      :"jpamb.cases.FuzzingChallenges.opaquePairSafe:(III)V" ()
      :"jpamb.cases.FuzzingChallenges.productTarget1031:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.productTarget257:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.productTarget509:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.productTargetSafe:(II)V" ()
      :"jpamb.cases.FuzzingChallenges.stagedMask3:(IIII)V" ()
      :"jpamb.cases.FuzzingChallenges.stagedMask4:(IIII)V" ()
      :"jpamb.cases.FuzzingChallenges.stagedMask5:(IIII)V" ()
      :"jpamb.cases.FuzzingChallenges.stagedMaskSafe:(IIII)V" ()
      :"jpamb.cases.Hospital.adminCombinesDepartments:(II)V" ()
      :"jpamb.cases.Hospital.combinedToOneDepartment:(II)V" ()
      :"jpamb.cases.Hospital.compartmentLeak:(I)V" ()
      :"jpamb.cases.Hospital.deadBranchLeak:(I)V" ()
      :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" ()
      :"jpamb.cases.Hospital.oncologyOnly:(II)V" ()
      :"jpamb.cases.Hospital.process:(II)V" ()
      :"jpamb.cases.Hospital.psychSessionCount:(I)V" ()
      :"jpamb.cases.Hospital.publicRiskScore:(I)I" ()
      :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" ()
      :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" ()
      :"jpamb.cases.InfoFlow.explicitLeak:(I)V" ()
      :"jpamb.cases.InfoFlow.explicitSafe:(I)V" ()
      :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" ()
      :"jpamb.cases.InfoFlow.implicitReturn:(I)I" ()
      :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" ()
      :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" ()
      :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" ()
      :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" ()
      :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" ()
      :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" ()
      :"jpamb.cases.PrecisionBenchmarks.bitwiseMaskBoundSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.bitwiseOrNonZeroSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.contradictoryRangeSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.correlatedBranchSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.helperPassthroughLeak:(I)V" ()
      :"jpamb.cases.PrecisionBenchmarks.helperPassthroughSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.intervalHullHoleSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.largeLoopWideningSafe:(I)V" ()
      :"jpamb.cases.PrecisionBenchmarks.loopExitBoundSafe:(I)V" ()
      :"jpamb.cases.PrecisionBenchmarks.overflowDeadBranchSafe:(I)V" ()
      :"jpamb.cases.PrecisionBenchmarks.overflowPrunedBySyntacticLeak:(I)V" ()
      :"jpamb.cases.PrecisionBenchmarks.paritySafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.recursiveCountdownLeak:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.relationalAlwaysLeak:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.relationalOrderSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.relationalSelfCancelSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.signHoleRangeSafe:(II)V" ()
      :"jpamb.cases.PrecisionBenchmarks.wideningOvershootSafe:(I)V" ()
    )
    :iterations 3
    :timeout 10.0
  )
  :results (
    :"jpamb.cases.AdvancedLeaks.computedDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114528041
          :relative 1.5944440447298402
        )
        :calibrates (2917000 2910708)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110658250
          :relative 1.57419858800012
        )
        :calibrates (2802042 3097458)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111849833
          :relative 1.5577263187812953
        )
        :calibrates (3052000 3141541)
      ))
    :"jpamb.cases.AdvancedLeaks.continueSkipsSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110978041
          :relative 1.5796590373085306
        )
        :calibrates (2858292 2984333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 141478959
          :relative 1.6708497457551472
        )
        :calibrates (3034958 3002750)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 135716250
          :relative 1.65084894356931
        )
        :calibrates (3025167 3039583)
      ))
    :"jpamb.cases.AdvancedLeaks.continueSkipsSinkSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115593584
          :relative 1.482562404408895
        )
        :calibrates (2863375 4746917)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107406791
          :relative 1.5705505101035562
        )
        :calibrates (2823333 2951125)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 116041791
          :relative 1.5857805075650624
        )
        :calibrates (2982416 3041292)
      ))
    :"jpamb.cases.AdvancedLeaks.doWhileLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113918083
          :relative 1.547070861755133
        )
        :calibrates (3443959 3020792)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107860500
          :relative 1.5759716117329245
        )
        :calibrates (2808041 2918875)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119443334
          :relative 1.59026820195053
        )
        :calibrates (3115375 3021167)
      ))
    :"jpamb.cases.AdvancedLeaks.earlyReturnBeforeSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 170353166
          :relative 1.721176787038198
        )
        :calibrates (3140666 3333792)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109922750
          :relative 1.5832845340904893
        )
        :calibrates (2809166 2929792)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111101375
          :relative 1.5773658992645876
        )
        :calibrates (2878500 3001584)
      ))
    :"jpamb.cases.AdvancedLeaks.earlyReturnSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109940458
          :relative 1.5211273398928595
        )
        :calibrates (3100333 3522750)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119344375
          :relative 1.6088024943327723
        )
        :calibrates (2803834 3071458)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111221833
          :relative 1.5768928149739816
        )
        :calibrates (2876250 3016625)
      ))
    :"jpamb.cases.AdvancedLeaks.forLoopLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113888625
          :relative 1.585072524366378
        )
        :calibrates (2934458 2987125)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 138854042
          :relative 1.6536701644765386
        )
        :calibrates (3089708 3075083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 116561500
          :relative 1.5815083037774147
        )
        :calibrates (2900209 3210292)
      ))
    :"jpamb.cases.AdvancedLeaks.forLoopSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110372667
          :relative 1.5840759017313353
        )
        :calibrates (2824541 2927416)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 129520542
          :relative 1.6405093220231526
        )
        :calibrates (2889083 3038250)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 120832209
          :relative 1.6063663021019554
        )
        :calibrates (2995125 2986875)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedThresholdLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112134292
          :relative 1.5908080181574684
        )
        :calibrates (2825542 2928333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 129719667
          :relative 1.652606053507475
        )
        :calibrates (2813792 2959583)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112529625
          :relative 1.5825964517681743
        )
        :calibrates (2880042 3004334)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedWhileSafe:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109246666
          :relative 1.579597339414858
        )
        :calibrates (2837583 2914708)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 159252167
          :relative 1.7284919002482038
        )
        :calibrates (2953417 2998042)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 130667500
          :relative 1.6148429606554258
        )
        :calibrates (2981125 3362750)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedWhileWeirdCaseLeak:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105890917
          :relative 1.560381532080708
        )
        :calibrates (2804375 3023459)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 133178292
          :relative 1.5873965910358023
        )
        :calibrates (2843916 4043667)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 125438625
          :relative 1.5198589430272476
        )
        :calibrates (3691791 3887042)
      ))
    :"jpamb.cases.AdvancedLeaks.overwrittenAfterBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111710250
          :relative 1.5866350920274825
        )
        :calibrates (2808209 2979250)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 137791583
          :relative 1.6407800062050775
        )
        :calibrates (3241875 3060042)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 125361042
          :relative 1.6097882390116927
        )
        :calibrates (2954166 3203333)
      ))
    :"jpamb.cases.AdvancedLeaks.ternaryDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 104833083
          :relative 1.56470525763531
        )
        :calibrates (2810542 2901917)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 122402583
          :relative 1.5949981463401808
        )
        :calibrates (3185792 3034667)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111954000
          :relative 1.5809539742202572
        )
        :calibrates (2877542 2998916)
      ))
    :"jpamb.cases.AdvancedLeaks.ternaryImplicitLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 127444958
          :relative 1.640305541783294
        )
        :calibrates (2904417 2930667)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112763125
          :relative 1.59054036267274
        )
        :calibrates (2877125 2912584)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113840500
          :relative 1.583330121553443
        )
        :calibrates (2996334 2946542)
      ))
    :"jpamb.cases.AdvancedLeaks.tripleNestedWhileCornerLeak:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113471583
          :relative 1.5640890372429659
        )
        :calibrates (2919417 3272542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111150667
          :relative 1.5864850543552311
        )
        :calibrates (2818041 2942417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112393958
          :relative 1.5892350594633948
        )
        :calibrates (2817583 2970542)
      ))
    :"jpamb.cases.BasicLeaks.explicitArithmetic:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 147662792
          :relative 1.69272919427393
        )
        :calibrates (3072209 2919792)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 120439875
          :relative 1.5789326048894654
        )
        :calibrates (3146708 3204666)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112672042
          :relative 1.5830597715009986
        )
        :calibrates (2852416 3033125)
      ))
    :"jpamb.cases.BasicLeaks.explicitConstantSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107361500
          :relative 1.5644567855244624
        )
        :calibrates (2816000 3037583)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 120612833
          :relative 1.5816778503058642
        )
        :calibrates (3053041 3267375)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112731750
          :relative 1.5851755899350064
        )
        :calibrates (2830875 3029166)
      ))
    :"jpamb.cases.BasicLeaks.explicitCopy:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109117041
          :relative 1.5568054878898077
        )
        :calibrates (2807000 3248041)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 138310041
          :relative 1.6738626371874517
        )
        :calibrates (2931416 2930250)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112958250
          :relative 1.5777736141735033
        )
        :calibrates (2907875 3064875)
      ))
    :"jpamb.cases.BasicLeaks.explicitDirect:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109959792
          :relative 1.5599226643602313
        )
        :calibrates (2928250 3129917)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110745791
          :relative 1.5843100634478402
        )
        :calibrates (2849250 2919041)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 140572417
          :relative 1.662569158480538
        )
        :calibrates (3076500 3038000)
      ))
    :"jpamb.cases.BasicLeaks.explicitDirectSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 142000083
          :relative 1.680257821915414
        )
        :calibrates (3010500 2919583)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111126291
          :relative 1.5670340239852822
        )
        :calibrates (2847416 3175583)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 182716000
          :relative 1.7725155685984184
        )
        :calibrates (2989625 3180458)
      ))
    :"jpamb.cases.BasicLeaks.explicitMixed:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108008584
          :relative 1.5674067210357885
        )
        :calibrates (2896708 2952291)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108901667
          :relative 1.565703057061154
        )
        :calibrates (2997833 2922709)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111258042
          :relative 1.5596766180530184
        )
        :calibrates (2994834 3138333)
      ))
    :"jpamb.cases.BasicLeaks.explicitMixedSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107794667
          :relative 1.5708986799251596
        )
        :calibrates (2868959 2921708)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109135792
          :relative 1.5795056014707565
        )
        :calibrates (2819125 2928542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 122272417
          :relative 1.6173010863627628
        )
        :calibrates (2873125 3029666)
      ))
    :"jpamb.cases.BasicLeaks.explicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110283333
          :relative 1.581781132375055
        )
        :calibrates (2813459 2964291)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108628125
          :relative 1.5690098201258342
        )
        :calibrates (2818042 3042833)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111681417
          :relative 1.5581454334083558
        )
        :calibrates (3069375 3108875)
      ))
    :"jpamb.cases.BasicLeaks.explicitReturnSafe:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 156231083
          :relative 1.7309110574678641
        )
        :calibrates (2850000 2956125)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 300331500
          :relative 1.8005702566862793
        )
        :calibrates (2985958 6521417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110638666
          :relative 1.5634927041663893
        )
        :calibrates (2995792 3049875)
      ))
    :"jpamb.cases.BasicLeaks.implicitAfterBranchSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105605875
          :relative 1.557720068317931
        )
        :calibrates (2809041 3038833)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 236161084
          :relative 1.7118907325394275
        )
        :calibrates (5873458 3296083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109336791
          :relative 1.5708562402492636
        )
        :calibrates (2888750 2985333)
      ))
    :"jpamb.cases.BasicLeaks.implicitIf:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107048542
          :relative 1.5633621723355307
        )
        :calibrates (2935958 2915291)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 122120958
          :relative 1.5996253033744592
        )
        :calibrates (3035625 3104750)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110340042
          :relative 1.562897005325571
        )
        :calibrates (3018750 3018875)
      ))
    :"jpamb.cases.BasicLeaks.implicitIfElse:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106928916
          :relative 1.5557116341840038
        )
        :calibrates (2940083 3008500)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112998792
          :relative 1.5652551628020965
        )
        :calibrates (3065292 3084333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 132495458
          :relative 1.6332275364378321
        )
        :calibrates (3027041 3138958)
      ))
    :"jpamb.cases.BasicLeaks.implicitIfSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107577375
          :relative 1.5736404812221518
        )
        :calibrates (2817583 2925042)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114920000
          :relative 1.5711522039198589
        )
        :calibrates (2933208 3236625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 117816709
          :relative 1.5991058835390193
        )
        :calibrates (2945084 2985958)
      ))
    :"jpamb.cases.BasicLeaks.implicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 118224667
          :relative 1.608864885527876
        )
        :calibrates (2819916 2999417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106934583
          :relative 1.546569152961478
        )
        :calibrates (3068875 3006583)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110185792
          :relative 1.5746808086243214
        )
        :calibrates (2907334 2960459)
      ))
    :"jpamb.cases.BasicLeaks.implicitSinkInBranch:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107982167
          :relative 1.5570518695656301
        )
        :calibrates (3066458 2922209)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107492458
          :relative 1.5482396285239868
        )
        :calibrates (2807750 3275958)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111554708
          :relative 1.578685393633936
        )
        :calibrates (2911000 2975166)
      ))
    :"jpamb.cases.BasicLeaks.implicitWhile:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111975792
          :relative 1.5752723727191174
        )
        :calibrates (2928042 3026958)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111155000
          :relative 1.5634514650633002
        )
        :calibrates (3050042 3024416)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109800583
          :relative 1.5753736755053056
        )
        :calibrates (2907333 2930625)
      ))
    :"jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109446500
          :relative 1.568846522475567
        )
        :calibrates (2977417 2929833)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107013750
          :relative 1.5594243857234722
        )
        :calibrates (2925542 2977083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109801125
          :relative 1.572333325304721
        )
        :calibrates (2844458 3034542)
      ))
    :"jpamb.cases.BasicLeaks.skippedLoop:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106968083
          :relative 1.563462543596677
        )
        :calibrates (2922417 2923083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 103970833
          :relative 1.5553410454479002
        )
        :calibrates (2813084 2975875)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110176375
          :relative 1.5697374143190461
        )
        :calibrates (2919875 3014583)
      ))
    :"jpamb.cases.BasicLeaks.staticFlagsButDynamicDoesnt:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113004541
          :relative 1.5828231834142514
        )
        :calibrates (2815667 3090459)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 124047375
          :relative 1.6161015248882376
        )
        :calibrates (2917084 3087958)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112132542
          :relative 1.5775909781772803
        )
        :calibrates (2932375 2999209)
      ))
    :"jpamb.cases.Clearance.flowDownOneLevel:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112841584
          :relative 1.5543540276281504
        )
        :calibrates (3290708 3006458)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112260584
          :relative 1.5755709864306429
        )
        :calibrates (2928292 3037750)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 117717125
          :relative 1.5905452586551518
        )
        :calibrates (2971458 3072541)
      ))
    :"jpamb.cases.Clearance.flowUpTwoLevels:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105244833
          :relative 1.5504080886639933
        )
        :calibrates (3004125 2922708)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112192333
          :relative 0.7466276080990963
        )
        :calibrates (2916166 37296750)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 166292334
          :relative 1.7223319734104048
        )
        :calibrates (3207541 3095792)
      ))
    :"jpamb.cases.Clearance.joinBecomesSecret:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 104458334
          :relative 1.5614144520781608
        )
        :calibrates (2816000 2919333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 135397875
          :relative 1.4753877863101588
        )
        :calibrates (4373209 4689417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114387333
          :relative 1.5747579060350592
        )
        :calibrates (2984875 3105584)
      ))
    :"jpamb.cases.Clearance.joinStaysConfidential:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112822833
          :relative 1.5933093046235065
        )
        :calibrates (2813292 2942667)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 174740875
          :relative 1.620995315973781
        )
        :calibrates (5085333 3278959)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111018208
          :relative 1.5698682978503402
        )
        :calibrates (3007792 2970208)
      ))
    :"jpamb.cases.Clearance.nestedBranches:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 104470583
          :relative 1.55064986386318
        )
        :calibrates (2852416 3027541)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 153244584
          :relative 1.671848458592241
        )
        :calibrates (3181208 3343584)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110018458
          :relative 1.555395341459466
        )
        :calibrates (3022250 3102667)
      ))
    :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106544125
          :relative 1.555178442185677
        )
        :calibrates (2902667 3031791)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 152307708
          :relative 1.6962530062595187
        )
        :calibrates (3143125 2987417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108333500
          :relative 1.568349251335845
        )
        :calibrates (2916209 2937667)
      ))
    :"jpamb.cases.Clearance.sequentialBranches:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 147819292
          :relative 1.6750547791873602
        )
        :calibrates (3100209 3147292)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 180719084
          :relative 1.772873300279009
        )
        :calibrates (2984125 3113500)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 130794375
          :relative 1.6296363318939948
        )
        :calibrates (2991459 3145917)
      ))
    :"jpamb.cases.Clearance.topSecretBroadcast:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107251500
          :relative 1.5621976564005275
        )
        :calibrates (2919500 2958583)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 116248000
          :relative 1.5688939531490438
        )
        :calibrates (3201709 3071959)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110225416
          :relative 1.5574245170315748
        )
        :calibrates (3023542 3084292)
      ))
    :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107182167
          :relative 1.5625205685760934
        )
        :calibrates (2925125 2944792)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 118342625
          :relative 1.6063693407905424
        )
        :calibrates (2890375 2968333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 123950833
          :relative 1.5654236450692014
        )
        :calibrates (3071125 3671916)
      ))
    :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106651708
          :relative 1.566022467912329
        )
        :calibrates (2855958 2938000)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 120429958
          :relative 1.5866379898815308
        )
        :calibrates (3026208 3212958)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 124166667
          :relative 1.5958237432891196
        )
        :calibrates (3293583 3004542)
      ))
    :"jpamb.cases.Compartments.implicitWithinSink:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105157208
          :relative 1.55985307521798
        )
        :calibrates (2844875 2949625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 123590000
          :relative 1.5711260609737525
        )
        :calibrates (3177417 3458291)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110823541
          :relative 1.577829328826599
        )
        :calibrates (2874916 2984208)
      ))
    :"jpamb.cases.Compartments.incomparableSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 104303083
          :relative 1.5475039854061574
        )
        :calibrates (2808666 3104542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 166371750
          :relative 1.7352398788655814
        )
        :calibrates (2932792 3188875)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109735542
          :relative 1.5677949715842083
        )
        :calibrates (2963917 2973292)
      ))
    :"jpamb.cases.Compartments.joinIsLeastUpperBound:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109099917
          :relative 1.549062248123337
        )
        :calibrates (3234250 2928750)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 123208791
          :relative 1.3887518220881683
        )
        :calibrates (6758334 3309125)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110904250
          :relative 1.5789645828195704
        )
        :calibrates (2872375 2975709)
      ))
    :"jpamb.cases.Compartments.joinOfThree:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105727917
          :relative 1.5666168133294043
        )
        :calibrates (2817833 2918084)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119065625
          :relative 1.5780707503871574
        )
        :calibrates (3099042 3192334)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113470667
          :relative 1.5799483656254223
        )
        :calibrates (2905500 3064375)
      ))
    :"jpamb.cases.Compartments.joinOfThreeToTop:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109850125
          :relative 1.578346477277759
        )
        :calibrates (2804458 2996291)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 120724208
          :relative 1.5916660660017643
        )
        :calibrates (3188417 2994000)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111187458
          :relative 1.5707025341816234
        )
        :calibrates (2851083 3124541)
      ))
    :"jpamb.cases.Compartments.joinOfTwo:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119948500
          :relative 1.6065888735360183
        )
        :calibrates (2898833 3036375)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109871916
          :relative 1.5666855907947568
        )
        :calibrates (3025875 2933917)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109895125
          :relative 1.5593656260124449
        )
        :calibrates (2869416 3192959)
      ))
    :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106317417
          :relative 1.5566505866924738
        )
        :calibrates (2934791 2967000)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111545750
          :relative 1.5765221805687668
        )
        :calibrates (2940458 2974625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110749458
          :relative 1.5587828610177241
        )
        :calibrates (2987000 3130708)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget19:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105985500
          :relative 1.5567546033813635
        )
        :calibrates (2873041 3008916)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115852208
          :relative 1.563893762576423
        )
        :calibrates (2995292 3329417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115140041
          :relative 1.5585120102733998
        )
        :calibrates (3109833 3254375)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget23:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106470750
          :relative 1.5704152605762633
        )
        :calibrates (2802667 2923250)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115992667
          :relative 1.5963572355107056
        )
        :calibrates (2910541 2965750)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 118675583
          :relative 1.5935911320863025
        )
        :calibrates (2994125 3056500)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget31:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105921875
          :relative 1.564726955594742
        )
        :calibrates (2807500 2964000)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110830083
          :relative 1.583972807482998
        )
        :calibrates (2815666 2961500)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 141058875
          :relative 1.6571407315162816
        )
        :calibrates (2995458 3217375)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTargetSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106288334
          :relative 1.568430322555593
        )
        :calibrates (2814667 2927625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111965125
          :relative 1.5851991080341792
        )
        :calibrates (2830916 2988959)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 152786959
          :relative 1.678535043137845
        )
        :calibrates (3257125 3148791)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair17:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113262917
          :relative 1.5976109478906986
        )
        :calibrates (2813125 2908334)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111137125
          :relative 1.5813416668400964
        )
        :calibrates (2899458 2928917)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 135354167
          :relative 1.6585689055667097
        )
        :calibrates (2917792 3024209)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair29:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108178750
          :relative 1.562159960362669
        )
        :calibrates (2938792 2990625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110835000
          :relative 1.551216016510885
        )
        :calibrates (2874541 3355500)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115630209
          :relative 1.566816449436502
        )
        :calibrates (3211125 3059125)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair53:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108426334
          :relative 1.5699533511146762
        )
        :calibrates (2917500 2919792)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119109042
          :relative 1.583781174269682
        )
        :calibrates (3285792 2925666)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114258416
          :relative 1.576585914728737
        )
        :calibrates (3007542 3050500)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePairSafe:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107471750
          :relative 1.567569186881338
        )
        :calibrates (2842834 2974917)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 118906750
          :relative 1.60401568040773
        )
        :calibrates (2821208 3097417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 138532541
          :relative 1.6616736547561979
        )
        :calibrates (2890625 3147584)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget1031:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105350875
          :relative 1.5557520732542127
        )
        :calibrates (2812916 3047333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 130694041
          :relative 1.6061298579958065
        )
        :calibrates (3405667 3068083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 212442750
          :relative 1.8314838124630108
        )
        :calibrates (3149666 3113416)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget257:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105170958
          :relative 1.562732689079263
        )
        :calibrates (2812084 2944875)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115546208
          :relative 1.5818359702135245
        )
        :calibrates (2982125 3070583)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 138822000
          :relative 1.6422647870248697
        )
        :calibrates (2902583 3424791)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget509:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105055625
          :relative 1.5424021619944626
        )
        :calibrates (3109833 2916417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111650125
          :relative 1.5778501968536482
        )
        :calibrates (2937916 2964625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 121642875
          :relative 1.5787310341560314
        )
        :calibrates (3430084 2987708)
      ))
    :"jpamb.cases.FuzzingChallenges.productTargetSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105610208
          :relative 1.562545153714689
        )
        :calibrates (2838542 2944958)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112132708
          :relative 1.581825258688063
        )
        :calibrates (2823500 3050542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 137764917
          :relative 1.6697369837987086
        )
        :calibrates (2906750 2987542)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask3:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105158167
          :relative 1.5650311402009114
        )
        :calibrates (2810750 2915125)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 121540875
          :relative 1.6048981597664633
        )
        :calibrates (2880042 3157417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 128599708
          :relative 1.643491704043991
        )
        :calibrates (2874333 2970583)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask4:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111439375
          :relative 1.580884958796464
        )
        :calibrates (2945958 2904417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 144360209
          :relative 1.6684654214627217
        )
        :calibrates (3015250 3179333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 191477833
          :relative 1.7986887652369412
        )
        :calibrates (2921708 3166083)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask5:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106143792
          :relative 1.5504382142150028
        )
        :calibrates (2883959 3093084)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 150169500
          :relative 1.6863686563135665
        )
        :calibrates (3040166 3143458)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 125764583
          :relative 1.626451760010897
        )
        :calibrates (2987625 2957166)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMaskSafe:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107807000
          :relative 1.554342058584402
        )
        :calibrates (2932791 3083584)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 120692375
          :relative 1.597935106553848
        )
        :calibrates (3068583 3023625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110783250
          :relative 1.497150718767853
        )
        :calibrates (2862667 4190000)
      ))
    :"jpamb.cases.Hospital.adminCombinesDepartments:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105082667
          :relative 1.5629467157909536
        )
        :calibrates (2819750 2929542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119609959
          :relative 1.5926288425757045
        )
        :calibrates (2877291 3234500)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 118464083
          :relative 1.5539802368003945
        )
        :calibrates (3473708 3142916)
      ))
    :"jpamb.cases.Hospital.combinedToOneDepartment:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 103988125
          :relative 1.5617644129047203
        )
        :calibrates (2804542 2900375)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 143808500
          :relative 1.624963892042841
        )
        :calibrates (3795541 3025500)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109793917
          :relative 1.5757970148862752
        )
        :calibrates (2885000 2946916)
      ))
    :"jpamb.cases.Hospital.compartmentLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 104548583
          :relative 1.5493611566441068
        )
        :calibrates (2934959 2966875)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109129584
          :relative 1.5670177463835775
        )
        :calibrates (2918667 2996333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108861416
          :relative 1.571299009660059
        )
        :calibrates (2866167 2976417)
      ))
    :"jpamb.cases.Hospital.deadBranchLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 104533166
          :relative 1.5508821052687694
        )
        :calibrates (2843250 3037084)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108433958
          :relative 1.5521221136890024
        )
        :calibrates (3098291 2984084)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108259166
          :relative 1.5658312349589354
        )
        :calibrates (2893458 2990417)
      ))
    :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 104600750
          :relative 1.5557506206139682
        )
        :calibrates (2807000 3011542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109150666
          :relative 1.5698022009764903
        )
        :calibrates (2894416 2983917)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 451073583
          :relative 2.0772681451971833
        )
        :calibrates (2926917 4624166)
      ))
    :"jpamb.cases.Hospital.oncologyOnly:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 104207292
          :relative 1.5407678077509417
        )
        :calibrates (3045875 2954250)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112667250
          :relative 1.5763837453001883
        )
        :calibrates (2829459 3147000)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 192798709
          :relative 1.6799158548435382
        )
        :calibrates (3775625 4282208)
      ))
    :"jpamb.cases.Hospital.process:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 173852792
          :relative 1.7789834561182145
        )
        :calibrates (2855541 2928458)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 124709792
          :relative 1.6221764299025176
        )
        :calibrates (3032625 2920625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 121036375
          :relative 1.6059877403259233
        )
        :calibrates (2993000 3004333)
      ))
    :"jpamb.cases.Hospital.psychSessionCount:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 117724292
          :relative 1.6148228578986898
        )
        :calibrates (2805500 2910250)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110057667
          :relative 1.573005239607528
        )
        :calibrates (2954042 2929584)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114941042
          :relative 1.4941727201893045
        )
        :calibrates (3110750 4256958)
      ))
    :"jpamb.cases.Hospital.publicRiskScore:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113923833
          :relative 1.5731252862681047
        )
        :calibrates (2864209 3224417)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115605667
          :relative 1.5687984310979248
        )
        :calibrates (2839167 3401208)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 137972750
          :relative 1.5934177444886413
        )
        :calibrates (3961625 3075667)
      ))
    :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 120633042
          :relative 1.5661306057901294
        )
        :calibrates (3478542 3073334)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 116668625
          :relative 1.5707569179909142
        )
        :calibrates (3154334 3115083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113139375
          :relative 1.5355496947246732
        )
        :calibrates (3250417 3342750)
      ))
    :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106350209
          :relative 1.5610364368000795
        )
        :calibrates (2865625 2978667)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112596459
          :relative 1.580997818267668
        )
        :calibrates (2897042 3012542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119832500
          :relative 1.5965531030345055
        )
        :calibrates (3013375 3054708)
      ))
    :"jpamb.cases.InfoFlow.explicitLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 138814917
          :relative 1.6822213805424884
        )
        :calibrates (2833000 2937916)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111251416
          :relative 1.577853570492146
        )
        :calibrates (2886209 2995208)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114862334
          :relative 1.5679733191061587
        )
        :calibrates (2942708 3269333)
      ))
    :"jpamb.cases.InfoFlow.explicitSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108280250
          :relative 1.5644788001266237
        )
        :calibrates (2896292 3007084)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110637208
          :relative 1.572982621782717
        )
        :calibrates (2946375 2968541)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111802583
          :relative 1.537000179053256
        )
        :calibrates (3013584 3479958)
      ))
    :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107752083
          :relative 1.561124793408415
        )
        :calibrates (2938833 2981292)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110851834
          :relative 1.5787996028602187
        )
        :calibrates (2864708 2982833)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 116917125
          :relative 1.5359285115678785
        )
        :calibrates (2996541 3810833)
      ))
    :"jpamb.cases.InfoFlow.implicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110871083
          :relative 1.5646465762722666
        )
        :calibrates (2805042 3237250)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119880375
          :relative 1.4947916656510913
        )
        :calibrates (2921167 4752208)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 127044584
          :relative 1.6074214938706628
        )
        :calibrates (3265583 3008708)
      ))
    :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115429042
          :relative 1.5884055648728885
        )
        :calibrates (2859625 3096167)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 142056375
          :relative 1.5493524218651071
        )
        :calibrates (4997667 3021667)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109634500
          :relative 1.5722405972984912
        )
        :calibrates (2884666 2986666)
      ))
    :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 122729000
          :relative 1.6052023973760532
        )
        :calibrates (3070542 3021667)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114667542
          :relative 1.5957744960391922
        )
        :calibrates (2878834 2938125)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109448542
          :relative 1.5702629550887282
        )
        :calibrates (2875667 3012458)
      ))
    :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107449333
          :relative 1.5535398678154266
        )
        :calibrates (2913959 3093542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113884542
          :relative 1.574207717224026
        )
        :calibrates (2978208 3093167)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108408750
          :relative 1.5677276206164603
        )
        :calibrates (2891875 2974458)
      ))
    :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114024250
          :relative 1.5977869371921316
        )
        :calibrates (2826750 2930834)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112594167
          :relative 1.5709640503625353
        )
        :calibrates (3046250 3001333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114255458
          :relative 1.5856387517028059
        )
        :calibrates (2846708 3086208)
      ))
    :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106498750
          :relative 1.3053365297039263
        )
        :calibrates (2893708 7651083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 118455333
          :relative 1.5938623648677541
        )
        :calibrates (3013916 3021709)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 140843000
          :relative 1.6603549176964227
        )
        :calibrates (2948042 3209542)
      ))
    :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 151569125
          :relative 1.5447982837509937
        )
        :calibrates (5485542 3161000)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 116761000
          :relative 1.5897725556944493
        )
        :calibrates (2918042 3087542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114210375
          :relative 1.5808285897409475
        )
        :calibrates (3033084 2963542)
      ))
    :"jpamb.cases.PrecisionBenchmarks.bitwiseMaskBoundSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112381708
          :relative 1.5789089423172349
        )
        :calibrates (2989709 2937042)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111221750
          :relative 1.5639147077512892
        )
        :calibrates (3045417 3026209)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113626625
          :relative 1.5751737193699957
        )
        :calibrates (3054041 2990125)
      ))
    :"jpamb.cases.PrecisionBenchmarks.bitwiseOrNonZeroSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107828667
          :relative 1.5717173922278664
        )
        :calibrates (2818084 2963500)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111115584
          :relative 1.5680449026058976
        )
        :calibrates (3032417 2976000)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119005166
          :relative 1.5945474394044583
        )
        :calibrates (2970958 3083125)
      ))
    :"jpamb.cases.PrecisionBenchmarks.contradictoryRangeSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 127144708
          :relative 1.616847673021594
        )
        :calibrates (2862916 3281500)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 122047000
          :relative 1.6071527259130352
        )
        :calibrates (3007417 3023792)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111432458
          :relative 1.5690528583947703
        )
        :calibrates (3016750 2994833)
      ))
    :"jpamb.cases.PrecisionBenchmarks.correlatedBranchSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 135180458
          :relative 1.6434721330432682
        )
        :calibrates (3124958 3019333)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112171583
          :relative 1.573767063106776
        )
        :calibrates (3000250 2985875)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109813667
          :relative 1.5715833350793378
        )
        :calibrates (2880167 3009667)
      ))
    :"jpamb.cases.PrecisionBenchmarks.helperPassthroughLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 114312417
          :relative 1.5807460166101097
        )
        :calibrates (2906750 3096375)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115435708
          :relative 1.5704068456081235
        )
        :calibrates (2921625 3286541)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 116472000
          :relative 1.5832051128827593
        )
        :calibrates (2949833 3132167)
      ))
    :"jpamb.cases.PrecisionBenchmarks.helperPassthroughSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 145514459
          :relative 1.6952857620136799
        )
        :calibrates (2938583 2931583)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 125106541
          :relative 1.608106998990094
        )
        :calibrates (3068750 3100083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 124881333
          :relative 1.605813509568996
        )
        :calibrates (3052416 3137917)
      ))
    :"jpamb.cases.PrecisionBenchmarks.intervalHullHoleSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105913042
          :relative 1.5561346102999434
        )
        :calibrates (2860250 3026083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115366042
          :relative 1.5678364096293038
        )
        :calibrates (3226666 3014584)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 190520875
          :relative 1.797191074860581
        )
        :calibrates (3033166 3045125)
      ))
    :"jpamb.cases.PrecisionBenchmarks.largeLoopWideningSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 105834375
          :relative 1.5601775929722497
        )
        :calibrates (2913083 2914375)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112646500
          :relative 1.581380727263737
        )
        :calibrates (2912375 2994625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112995791
          :relative 1.5820182180886644
        )
        :calibrates (2932709 2983916)
      ))
    :"jpamb.cases.PrecisionBenchmarks.loopExitBoundSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 130403542
          :relative 1.6450291028207908
        )
        :calibrates (2895416 3010541)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113262125
          :relative 1.5882713425726451
        )
        :calibrates (2870875 2974917)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113396167
          :relative 1.5651350484186775
        )
        :calibrates (2875250 3297708)
      ))
    :"jpamb.cases.PrecisionBenchmarks.overflowDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 106631750
          :relative 1.5607102767995722
        )
        :calibrates (2925166 2939000)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110125792
          :relative 1.5805093124327296
        )
        :calibrates (2866042 2920375)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" -4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 8.999999999999991
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 183624125
          :relative 1.7879166968240836
        )
        :calibrates (3013042 2971667)
      ))
    :"jpamb.cases.PrecisionBenchmarks.overflowPrunedBySyntacticLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 122920000
          :relative 1.6101791908165588
        )
        :calibrates (2833959 3198208)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109598375
          :relative 1.5728655014249169
        )
        :calibrates (2887708 2973250)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok -4.000000000000001
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110517625
          :relative 1.5713976180051836
        )
        :calibrates (2936209 2993917)
      ))
    :"jpamb.cases.PrecisionBenchmarks.paritySafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 113032166
          :relative 1.55197444560516
        )
        :calibrates (3292500 3049958)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 134416625
          :relative 1.649117634023087
        )
        :calibrates (2860542 3170125)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 115887875
          :relative 1.5940595919754994
        )
        :calibrates (2876750 3025375)
      ))
    :"jpamb.cases.PrecisionBenchmarks.recursiveCountdownLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 119498291
          :relative 1.6022566923080237
        )
        :calibrates (3016667 2955542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 120400333
          :relative 1.5983289248836157
        )
        :calibrates (3036667 3035291)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 118653250
          :relative 1.5620845658365168
        )
        :calibrates (2869417 3635250)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalAlwaysLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109882417
          :relative 1.5779191791618674
        )
        :calibrates (2800000 3008166)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 159876667
          :relative 1.7251344087272666
        )
        :calibrates (2999625 3021542)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 156818916
          :relative 1.6617931886986566
        )
        :calibrates (3507292 3326083)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalOrderSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107189000
          :relative 1.550724929982585
        )
        :calibrates (2814833 3217083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111804750
          :relative 1.5847476623881511
        )
        :calibrates (2834875 2982708)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111627041
          :relative 1.5612297716956838
        )
        :calibrates (2970000 3161541)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalSelfCancelSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 107231875
          :relative 1.564287792949797
        )
        :calibrates (2941041 2907750)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111907834
          :relative 1.5617190730163846
        )
        :calibrates (3051959 3088084)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 112383250
          :relative 1.5797645725637859
        )
        :calibrates (2879292 3035875)
      ))
    :"jpamb.cases.PrecisionBenchmarks.signHoleRangeSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108943292
          :relative 1.5548599628844466
        )
        :calibrates (3172500 2900042)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 110549167
          :relative 1.5486793959035843
        )
        :calibrates (3127292 3123083)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 108205041
          :relative 1.5543424495586733
        )
        :calibrates (2856833 3181750)
      ))
    :"jpamb.cases.PrecisionBenchmarks.wideningOvershootSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 109816834
          :relative 1.5723923517752285
        )
        :calibrates (2977958 2901084)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 111786167
          :relative 1.5667364378081834
        )
        :calibrates (3037292 3025625)
      ) (analysis-result
        :response (response
          :predictions (
            :* -8.999999999999991
            :"assertion error" 4.000000000000001
            :"divide by zero" -8.999999999999991
            :"null pointer" -8.999999999999991
            :ok 1.5000000000000007
            :"out of bounds" -8.999999999999991
          )
        )
        :duration (duration
          :absolute 118995500
          :relative 1.6025091330875534
        )
        :calibrates (2879000 3064625)
      ))
  )
)