(analysis-summary
  :config (analysis-config
    :cmd (/Users/Bruger/Desktop/program-analysis-project/solutions/project-unbounded-confidentiality/.venv/bin/python /Users/Bruger/Desktop/program-analysis-project/solutions/project-unbounded-confidentiality/src/unbounded_analysis.py)
    :analysis (analysis-info
      :name project-unbounded-confidentiality
      :version 0.1.0
      :group "loop cancelled"
      :tags (static python)
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
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 133971666
          :relative 1.6420698427820952
        )
        :calibrates (3052000 3057042)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115671209
          :relative 1.5895345626541966
        )
        :calibrates (2904625 3048167)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111229000
          :relative 1.5591444526000195
        )
        :calibrates (3013584 3125500)
      ))
    :"jpamb.cases.AdvancedLeaks.continueSkipsSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 121293042
          :relative 1.57295309074157
        )
        :calibrates (2907500 3577542)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 159900750
          :relative 1.7166148796806229
        )
        :calibrates (3064250 3077125)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 123725291
          :relative 1.5637666985012213
        )
        :calibrates (3654125 3102375)
      ))
    :"jpamb.cases.AdvancedLeaks.continueSkipsSinkSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 119394792
          :relative 1.592813074367948
        )
        :calibrates (3117875 2980334)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111753917
          :relative 1.57117465188143
        )
        :calibrates (2907167 3092375)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109012291
          :relative 1.5630102834903712
        )
        :calibrates (2906875 3056542)
      ))
    :"jpamb.cases.AdvancedLeaks.doWhileLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110365458
          :relative 1.5687596051889063
        )
        :calibrates (2984417 2973625)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115952500
          :relative 1.5304206491514682
        )
        :calibrates (3758834 3078542)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109670375
          :relative 1.570279605409654
        )
        :calibrates (2875333 3024500)
      ))
    :"jpamb.cases.AdvancedLeaks.earlyReturnBeforeSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109880333
          :relative 1.555811029298789
        )
        :calibrates (3056125 3055250)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111652208
          :relative 1.5762455345144015
        )
        :calibrates (2899042 3025459)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108666750
          :relative 1.569389687768119
        )
        :calibrates (2889291 2968542)
      ))
    :"jpamb.cases.AdvancedLeaks.earlyReturnSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108832500
          :relative 1.5610269251839004
        )
        :calibrates (2961000 3019833)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113135458
          :relative 1.582221498280144
        )
        :calibrates (2922750 2998416)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107962042
          :relative 1.5604141214183478
        )
        :calibrates (2872167 3069208)
      ))
    :"jpamb.cases.AdvancedLeaks.forLoopLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 116774666
          :relative 1.5857507333529262
        )
        :calibrates (2990250 3071917)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115512459
          :relative 1.5937309290275523
        )
        :calibrates (2907042 2980417)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 120855791
          :relative 1.604118944615871
        )
        :calibrates (2979542 3034667)
      ))
    :"jpamb.cases.AdvancedLeaks.forLoopSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115162375
          :relative 1.5870002131875196
        )
        :calibrates (2977167 2984125)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109855500
          :relative 1.5514786605241055
        )
        :calibrates (3069708 3101542)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114152709
          :relative 1.5700179366995426
        )
        :calibrates (3156791 2987875)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedThresholdLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113322750
          :relative 1.58577903710551
        )
        :calibrates (2877791 3004792)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113617583
          :relative 1.5449759409293964
        )
        :calibrates (3035250 3443625)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110195792
          :relative 1.5671811757876293
        )
        :calibrates (2899709 3070834)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedWhileSafe:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 145537084
          :relative 1.6861027849138304
        )
        :calibrates (2922334 3074208)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 182758709
          :relative 1.775155384715711
        )
        :calibrates (3084167 3049959)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 140444708
          :relative 1.667723191748099
        )
        :calibrates (2886667 3150208)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedWhileWeirdCaseLeak:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 131126458
          :relative 1.630410584430984
        )
        :calibrates (3013166 3128833)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 124896125
          :relative 1.626840542181787
        )
        :calibrates (2894416 3004041)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 121070208
          :relative 1.6086268012698777
        )
        :calibrates (2964500 2998166)
      ))
    :"jpamb.cases.AdvancedLeaks.overwrittenAfterBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109403542
          :relative 1.5600863070213706
        )
        :calibrates (2995375 3029875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114964625
          :relative 1.5915342320967512
        )
        :calibrates (2875708 3013542)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108069333
          :relative 1.562958227903708
        )
        :calibrates (2872000 3040542)
      ))
    :"jpamb.cases.AdvancedLeaks.ternaryDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107528708
          :relative 1.5616962285048015
        )
        :calibrates (2926042 2974042)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111136041
          :relative 1.554951720675461
        )
        :calibrates (2922083 3271375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108771000
          :relative 1.5680703747521507
        )
        :calibrates (2908417 2972875)
      ))
    :"jpamb.cases.AdvancedLeaks.ternaryImplicitLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107171416
          :relative 1.5495539858308123
        )
        :calibrates (3065167 2982042)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114628916
          :relative 1.572766302389896
        )
        :calibrates (2977750 3153625)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110024875
          :relative 1.572805112890997
        )
        :calibrates (2860750 3023834)
      ))
    :"jpamb.cases.AdvancedLeaks.tripleNestedWhileCornerLeak:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 160737208
          :relative 1.7366195844864032
        )
        :calibrates (2875209 3020375)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 161047333
          :relative 1.690123511464024
        )
        :calibrates (3536750 3037709)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 154454375
          :relative 1.7047377355896711
        )
        :calibrates (2922167 3174500)
      ))
    :"jpamb.cases.BasicLeaks.explicitArithmetic:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108194959
          :relative 1.5602732187088797
        )
        :calibrates (2980333 2975792)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 121621208
          :relative 1.5287495799997706
        )
        :calibrates (3207333 3991958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107485042
          :relative 1.5586342084687013
        )
        :calibrates (2958875 2980542)
      ))
    :"jpamb.cases.BasicLeaks.explicitConstantSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109660375
          :relative 1.5732654899819716
        )
        :calibrates (2874792 2984083)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 164150625
          :relative 1.6811847525556696
        )
        :calibrates (3724458 3116041)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 139690959
          :relative 1.6616464005812963
        )
        :calibrates (3060958 3028125)
      ))
    :"jpamb.cases.BasicLeaks.explicitCopy:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 119138083
          :relative 1.5765038689243454
        )
        :calibrates (2884458 3433500)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 120397542
          :relative 1.5948813630599894
        )
        :calibrates (2996084 3124125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 150886667
          :relative 1.689454334191455
        )
        :calibrates (2955667 3213500)
      ))
    :"jpamb.cases.BasicLeaks.explicitDirect:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111846542
          :relative 1.558699290771137
        )
        :calibrates (3070458 3109041)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110198000
          :relative 1.5684465236117449
        )
        :calibrates (2953542 2999750)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106126958
          :relative 1.5484693543535204
        )
        :calibrates (2979208 3024041)
      ))
    :"jpamb.cases.BasicLeaks.explicitDirectSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 104974208
          :relative 1.546930106977241
        )
        :calibrates (2980250 2978875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106036250
          :relative 1.5588554780316943
        )
        :calibrates (2882375 2974000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106496458
          :relative 1.5414540994477532
        )
        :calibrates (3067375 3054875)
      ))
    :"jpamb.cases.BasicLeaks.explicitMixed:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 103335500
          :relative 1.5401092164218024
        )
        :calibrates (2970291 2988667)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107436000
          :relative 1.5482971049965875
        )
        :calibrates (2870583 3209125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109271834
          :relative 1.5692171897092533
        )
        :calibrates (2877666 3015125)
      ))
    :"jpamb.cases.BasicLeaks.explicitMixedSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 102948042
          :relative 1.5422903062083047
        )
        :calibrates (2898000 3008875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105823375
          :relative 1.5524684494713192
        )
        :calibrates (2888667 3042541)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106859208
          :relative 1.557703680095371
        )
        :calibrates (2882416 3035084)
      ))
    :"jpamb.cases.BasicLeaks.explicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 104417875
          :relative 1.5465274968162497
        )
        :calibrates (2941000 2992041)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105166875
          :relative 1.5392882691140048
        )
        :calibrates (3022375 3053666)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112890792
          :relative 1.5829040088351927
        )
        :calibrates (2904041 2995042)
      ))
    :"jpamb.cases.BasicLeaks.explicitReturnSafe:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110922791
          :relative 1.5740654191762293
        )
        :calibrates (2837083 3078334)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111043417
          :relative 1.5663075684355308
        )
        :calibrates (2960875 3067708)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107280709
          :relative 1.550538636453421
        )
        :calibrates (3021667 3018000)
      ))
    :"jpamb.cases.BasicLeaks.implicitAfterBranchSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110769667
          :relative 1.5558584303881466
        )
        :calibrates (3093458 3066708)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109755333
          :relative 1.5628732642750938
        )
        :calibrates (2914292 3091667)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110033584
          :relative 1.5664839637232166
        )
        :calibrates (2888583 3082750)
      ))
    :"jpamb.cases.BasicLeaks.implicitIf:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107387292
          :relative 1.5585102851477715
        )
        :calibrates (2886125 3049584)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108317083
          :relative 1.563090495388697
        )
        :calibrates (2916042 3008250)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110408792
          :relative 1.5697265870459611
        )
        :calibrates (2963750 2983375)
      ))
    :"jpamb.cases.BasicLeaks.implicitIfElse:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109516583
          :relative 1.5651118629994731
        )
        :calibrates (2964000 2998083)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 116459417
          :relative 1.5985326220944451
        )
        :calibrates (2905833 2964625)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108102917
          :relative 1.5617517132099479
        )
        :calibrates (2890875 3039958)
      ))
    :"jpamb.cases.BasicLeaks.implicitIfSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106294334
          :relative 1.5491325575682942
        )
        :calibrates (2927834 3075708)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110431000
          :relative 1.5553724488795404
        )
        :calibrates (3111375 3036833)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106927625
          :relative 1.547366739726205
        )
        :calibrates (2895166 3168750)
      ))
    :"jpamb.cases.BasicLeaks.implicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107306667
          :relative 1.5546318053935158
        )
        :calibrates (2874125 3110334)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106147875
          :relative 1.5400864259099534
        )
        :calibrates (3132500 2988958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105854959
          :relative 1.5461537305201984
        )
        :calibrates (2980458 3039417)
      ))
    :"jpamb.cases.BasicLeaks.implicitSinkInBranch:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106237875
          :relative 1.5549693977770243
        )
        :calibrates (2941666 2978583)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109325166
          :relative 1.5634061986611756
        )
        :calibrates (2878625 3096458)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110226250
          :relative 1.565942659191811
        )
        :calibrates (2961958 3027291)
      ))
    :"jpamb.cases.BasicLeaks.implicitWhile:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 119915750
          :relative 1.6064794269224156
        )
        :calibrates (2934167 3000916)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109267000
          :relative 1.570652876599575
        )
        :calibrates (2821875 3051208)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114975500
          :relative 1.5776008117985987
        )
        :calibrates (2895875 3185958)
      ))
    :"jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106807583
          :relative 1.5465149454929072
        )
        :calibrates (2916375 3152625)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110769583
          :relative 1.5721853913830715
        )
        :calibrates (2912583 3020291)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114382458
          :relative 1.5741782852987531
        )
        :calibrates (3107042 2991291)
      ))
    :"jpamb.cases.BasicLeaks.skippedLoop:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 118232750
          :relative 1.6012108030721675
        )
        :calibrates (2877208 3046000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109123667
          :relative 1.563991268613818
        )
        :calibrates (2874166 3081875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106058667
          :relative 1.541611356958559
        )
        :calibrates (2915000 3179875)
      ))
    :"jpamb.cases.BasicLeaks.staticFlagsButDynamicDoesnt:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107324625
          :relative 1.5433105437105257
        )
        :calibrates (3132000 3011542)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 148035708
          :relative 1.691403389980212
        )
        :calibrates (2932750 3092750)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110414916
          :relative 1.531601236153604
        )
        :calibrates (2978625 3514541)
      ))
    :"jpamb.cases.Clearance.flowDownOneLevel:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107931875
          :relative 1.5630732395740903
        )
        :calibrates (2874416 3029042)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 119114000
          :relative 1.5598379944737804
        )
        :calibrates (3089125 3474667)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 129922375
          :relative 1.6392187675635779
        )
        :calibrates (2976500 2986917)
      ))
    :"jpamb.cases.Clearance.flowUpTwoLevels:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 142164375
          :relative 1.679176095128661
        )
        :calibrates (2940042 3011708)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114630167
          :relative 1.5478417158128652
        )
        :calibrates (3440625 3053000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105700083
          :relative 1.5417734895856727
        )
        :calibrates (2881334 3190667)
      ))
    :"jpamb.cases.Clearance.joinBecomesSecret:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 102839292
          :relative 1.5444400824815168
        )
        :calibrates (2895458 2976041)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110665417
          :relative 1.5710910742617064
        )
        :calibrates (2919791 3022458)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105128375
          :relative 1.5383496419808285
        )
        :calibrates (3040833 3046125)
      ))
    :"jpamb.cases.Clearance.joinStaysConfidential:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 103523042
          :relative 1.5435374600298712
        )
        :calibrates (2945375 2977459)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108669750
          :relative 1.561291656895958
        )
        :calibrates (2912708 3055542)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107918334
          :relative 1.5632303042097957
        )
        :calibrates (2881208 3019375)
      ))
    :"jpamb.cases.Clearance.nestedBranches:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112982667
          :relative 1.5700281074877678
        )
        :calibrates (2881375 3200167)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110647291
          :relative 1.5634308125318572
        )
        :calibrates (2885708 3161292)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 127705500
          :relative 1.6342123687757593
        )
        :calibrates (2888750 3040875)
      ))
    :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 188896875
          :relative 1.7751055770654434
        )
        :calibrates (3216000 3124875)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 172464875
          :relative 1.754738763298802
        )
        :calibrates (3072208 2995042)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112611250
          :relative 1.5850663321339686
        )
        :calibrates (2875709 2979541)
      ))
    :"jpamb.cases.Clearance.sequentialBranches:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115404000
          :relative 1.5633763854933664
        )
        :calibrates (3004417 3303333)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 141761000
          :relative 1.6738417322718073
        )
        :calibrates (2896792 3111417)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 153405500
          :relative 1.7107905441235143
        )
        :calibrates (2878208 3093250)
      ))
    :"jpamb.cases.Clearance.topSecretBroadcast:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110077875
          :relative 1.53513581753029
        )
        :calibrates (3432917 2987958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112348541
          :relative 1.5688591530224507
        )
        :calibrates (3039625 3024083)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111613416
          :relative 1.571219892941136
        )
        :calibrates (2966584 3024791)
      ))
    :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 124608250
          :relative 1.625617398250255
        )
        :calibrates (2862667 3038792)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 121095375
          :relative 1.5097505972168779
        )
        :calibrates (2974375 4514334)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 130782875
          :relative 1.6417156776893866
        )
        :calibrates (2907833 3060667)
      ))
    :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114057959
          :relative 1.5788056070953664
        )
        :calibrates (2956750 3059834)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 121493875
          :relative 1.5370796667786821
        )
        :calibrates (4042250 3012875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106968375
          :relative 1.5621623146295314
        )
        :calibrates (2878334 2984709)
      ))
    :"jpamb.cases.Compartments.implicitWithinSink:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106662250
          :relative 1.5604797348011499
        )
        :calibrates (2873833 2995125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113320334
          :relative 1.5463198851374775
        )
        :calibrates (3205292 3236667)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107216709
          :relative 1.5605999970259936
        )
        :calibrates (2902292 2995541)
      ))
    :"jpamb.cases.Compartments.incomparableSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 104673000
          :relative 1.5445691351470745
        )
        :calibrates (2888500 3085917)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109729208
          :relative 1.5448327870021883
        )
        :calibrates (3078209 3181000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105856167
          :relative 1.554526258063756
        )
        :calibrates (2892875 3012125)
      ))
    :"jpamb.cases.Compartments.joinIsLeastUpperBound:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 104136417
          :relative 1.5500500179520293
        )
        :calibrates (2962084 2907166)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105809208
          :relative 1.5478125938842406
        )
        :calibrates (2969291 3025042)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 139755959
          :relative 1.6600690002591283
        )
        :calibrates (3097917 3016166)
      ))
    :"jpamb.cases.Compartments.joinOfThree:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108308334
          :relative 1.5668842284682531
        )
        :calibrates (2827792 3044500)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107345417
          :relative 1.5613296936535024
        )
        :calibrates (2901458 2993542)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107599250
          :relative 1.555784228233788
        )
        :calibrates (2921083 3063791)
      ))
    :"jpamb.cases.Compartments.joinOfThreeToTop:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105988917
          :relative 1.5469375062665631
        )
        :calibrates (2984208 3032417)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111281167
          :relative 1.5720991785108744
        )
        :calibrates (2894750 3066708)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113242417
          :relative 1.575589901268977
        )
        :calibrates (3029209 2988750)
      ))
    :"jpamb.cases.Compartments.joinOfTwo:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115528458
          :relative 1.5924745799811535
        )
        :calibrates (2889250 3016083)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 130079375
          :relative 1.6441380654596245
        )
        :calibrates (2929750 2973625)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108070250
          :relative 1.5315722155685163
        )
        :calibrates (3276541 3079167)
      ))
    :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108760667
          :relative 1.5586785504899197
        )
        :calibrates (2965417 3043875)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113565709
          :relative 1.5366647820238442
        )
        :calibrates (3026166 3574875)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 158087542
          :relative 1.728713845098386
        )
        :calibrates (2872375 3032542)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget19:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107645166
          :relative 1.5639119949438065
        )
        :calibrates (2868916 3007500)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 121207167
          :relative 1.6037071228653013
        )
        :calibrates (3017042 3020375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108714417
          :relative 1.5622652601317586
        )
        :calibrates (2906875 3050458)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget23:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106316958
          :relative 1.5523771693309658
        )
        :calibrates (2864000 3096125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110639834
          :relative 1.5698622974659695
        )
        :calibrates (2928708 3029000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106737458
          :relative 1.5592775691343383
        )
        :calibrates (2903417 2985959)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget31:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109585875
          :relative 1.55549325894938
        )
        :calibrates (2929667 3169792)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 141280084
          :relative 1.6724442710016898
        )
        :calibrates (2971041 3036084)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106638209
          :relative 1.5483105426497847
        )
        :calibrates (2890792 3143583)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTargetSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109316292
          :relative 1.5420636471971554
        )
        :calibrates (3176208 3099334)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113394916
          :relative 1.5821967825129795
        )
        :calibrates (2906208 3028875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105787708
          :relative 1.5436320216907007
        )
        :calibrates (3038917 3012167)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair17:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107668041
          :relative 1.5469098002988542
        )
        :calibrates (3028375 3083958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 126220791
          :relative 1.5692663321626374
        )
        :calibrates (3715083 3090958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108103458
          :relative 1.563539373697975
        )
        :calibrates (2876625 3029875)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair29:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106151208
          :relative 1.550856299963435
        )
        :calibrates (2976334 2995375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 127689459
          :relative 1.6000673270766483
        )
        :calibrates (3116750 3297084)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107420875
          :relative 1.5637026670837004
        )
        :calibrates (2880416 2986583)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair53:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106630125
          :relative 1.5442124019479089
        )
        :calibrates (3019667 3071458)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 116142208
          :relative 1.531358254286902
        )
        :calibrates (3860834 2972959)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113521583
          :relative 1.5797039499449401
        )
        :calibrates (2890000 3085916)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePairSafe:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112501416
          :relative 1.5559896242980034
        )
        :calibrates (2882458 3372125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110065458
          :relative 1.5713784064216705
        )
        :calibrates (2901750 3004375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111892083
          :relative 1.5713976404406957
        )
        :calibrates (2993292 3010584)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget1031:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110515625
          :relative 1.563851324890468
        )
        :calibrates (2958167 3075792)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111949708
          :relative 1.5682347795079192
        )
        :calibrates (2884375 3166500)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107676625
          :relative 1.5584458976212139
        )
        :calibrates (2914792 3037792)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget257:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 157354709
          :relative 1.7286986296529578
        )
        :calibrates (2883208 2994542)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110713458
          :relative 1.539307833059974
        )
        :calibrates (3387625 3008583)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108475333
          :relative 1.5649510820879902
        )
        :calibrates (2900209 3007375)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget509:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107976792
          :relative 1.5672571881776762
        )
        :calibrates (2891791 2957500)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112254000
          :relative 1.5777410016144522
        )
        :calibrates (2909875 3026083)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107639584
          :relative 1.5640588223500145
        )
        :calibrates (2897042 2977083)
      ))
    :"jpamb.cases.FuzzingChallenges.productTargetSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110145833
          :relative 1.5772022226535332
        )
        :calibrates (2817667 3014042)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111428875
          :relative 1.5759811506295642
        )
        :calibrates (2872292 3043959)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 127229166
          :relative 1.6268476470296416
        )
        :calibrates (2900500 3108041)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask3:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114437084
          :relative 1.5913966699081477
        )
        :calibrates (2884542 2979541)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108439416
          :relative 1.5673078445703603
        )
        :calibrates (2874500 2999167)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114564375
          :relative 1.583959714066671
        )
        :calibrates (2943084 3028917)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask4:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 118712000
          :relative 1.5653089068781856
        )
        :calibrates (2880125 3579625)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112129500
          :relative 1.575770911436471
        )
        :calibrates (2913333 3043000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 120400750
          :relative 1.607994640310782
        )
        :calibrates (2866666 3071667)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask5:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 119308875
          :relative 1.5956005770432404
        )
        :calibrates (3010500 3044333)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 141904667
          :relative 1.6824876148861536
        )
        :calibrates (2905375 2990375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109717625
          :relative 1.5291369856494774
        )
        :calibrates (3040584 3448291)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMaskSafe:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110843375
          :relative 1.5772711689955388
        )
        :calibrates (2896584 2971125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109093875
          :relative 1.5635780560152426
        )
        :calibrates (2900750 3059333)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 116823458
          :relative 1.5772759647289385
        )
        :calibrates (3141792 3042416)
      ))
    :"jpamb.cases.Hospital.adminCombinesDepartments:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 116210625
          :relative 1.581403101580855
        )
        :calibrates (2840208 3253375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115563167
          :relative 1.5622627107488707
        )
        :calibrates (2922709 3409959)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 121161000
          :relative 1.6131852253383119
        )
        :calibrates (2928000 2976833)
      ))
    :"jpamb.cases.Hospital.combinedToOneDepartment:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 168905166
          :relative 1.7466035396128952
        )
        :calibrates (3034667 3019709)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 117437000
          :relative 1.5439721907745654
        )
        :calibrates (3718709 2993458)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110114167
          :relative 1.5694281034895976
        )
        :calibrates (2894333 3041000)
      ))
    :"jpamb.cases.Hospital.compartmentLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108195959
          :relative 1.5414447865950804
        )
        :calibrates (3202375 3017709)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111301083
          :relative 1.5771714995655304
        )
        :calibrates (2912333 2980958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105341083
          :relative 1.5488675261757703
        )
        :calibrates (2913792 3039542)
      ))
    :"jpamb.cases.Hospital.deadBranchLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112911917
          :relative 1.5807944058910888
        )
        :calibrates (2897125 3031792)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105735042
          :relative 1.535753400825123
        )
        :calibrates (2914917 3243875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105099000
          :relative 1.5405591906568403
        )
        :calibrates (3031709 3022667)
      ))
    :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 122497291
          :relative 1.6159522628902636
        )
        :calibrates (2890959 3041083)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106000292
          :relative 1.546638352927046
        )
        :calibrates (3031833 2989584)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106606791
          :relative 1.560531448127273
        )
        :calibrates (2879250 2985958)
      ))
    :"jpamb.cases.Hospital.oncologyOnly:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107768417
          :relative 1.5568777650447347
        )
        :calibrates (2955000 3024209)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110059959
          :relative 1.5467358977329995
        )
        :calibrates (3101125 3149500)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108052917
          :relative 1.5641151301725758
        )
        :calibrates (2872375 3023542)
      ))
    :"jpamb.cases.Hospital.process:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 104281625
          :relative 1.5453904414406785
        )
        :calibrates (2897958 3042875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109898208
          :relative 1.5509120494667739
        )
        :calibrates (3116792 3064917)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106604375
          :relative 1.5433595111826994
        )
        :calibrates (2899250 3202375)
      ))
    :"jpamb.cases.Hospital.psychSessionCount:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106288208
          :relative 1.5443651701564378
        )
        :calibrates (3027083 3042375)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108138875
          :relative 1.5539360064014127
        )
        :calibrates (3008125 3032416)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 127626250
          :relative 1.607715632993116
        )
        :calibrates (2966375 3332375)
      ))
    :"jpamb.cases.Hospital.publicRiskScore:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 117519500
          :relative 1.586231494512935
        )
        :calibrates (2888375 3205709)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106277333
          :relative 1.557967183075966
        )
        :calibrates (2879958 3001750)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109720875
          :relative 1.5370094138725614
        )
        :calibrates (3145250 3227250)
      ))
    :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 131977500
          :relative 1.6474084979131427
        )
        :calibrates (2933333 3011250)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108508625
          :relative 1.5483200140281783
        )
        :calibrates (2929166 3210917)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105954792
          :relative 1.5467495119904107
        )
        :calibrates (3037875 2979417)
      ))
    :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 104412583
          :relative 1.5424557163354609
        )
        :calibrates (2825375 3163250)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 118048959
          :relative 1.5851832379119961
        )
        :calibrates (3019250 3117083)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106560542
          :relative 1.5393337313789457
        )
        :calibrates (3132541 3023375)
      ))
    :"jpamb.cases.InfoFlow.explicitLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105706709
          :relative 1.552871954594031
        )
        :calibrates (2923125 2996042)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 120773042
          :relative 1.5841048661886756
        )
        :calibrates (3160667 3132875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105894083
          :relative 1.558034979210528
        )
        :calibrates (2882250 2977333)
      ))
    :"jpamb.cases.InfoFlow.explicitSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111933083
          :relative 1.5763452695524123
        )
        :calibrates (2873333 3064708)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 156305083
          :relative 1.621314460200991
        )
        :calibrates (4501958 2974375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106923917
          :relative 1.5537638933869764
        )
        :calibrates (2905959 3069083)
      ))
    :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115534125
          :relative 1.5551579130904432
        )
        :calibrates (3159667 3275834)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109339208
          :relative 1.565998198910231
        )
        :calibrates (2900208 3040083)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105730541
          :relative 1.556022369320183
        )
        :calibrates (2878667 2999042)
      ))
    :"jpamb.cases.InfoFlow.implicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113724083
          :relative 1.566591433095581
        )
        :calibrates (3103708 3066375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109950917
          :relative 1.56705247791668
        )
        :calibrates (2936083 3022958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105647042
          :relative 1.516876199473239
        )
        :calibrates (3388792 3038250)
      ))
    :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 104590291
          :relative 1.5420866872023085
        )
        :calibrates (2942625 3061292)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105531666
          :relative 1.551471042481636
        )
        :calibrates (2891791 3036667)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107546042
          :relative 1.5634040813640238
        )
        :calibrates (2881958 2995917)
      ))
    :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106695417
          :relative 1.555331486835069
        )
        :calibrates (2957458 2983333)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107780708
          :relative 1.5462286719045886
        )
        :calibrates (3117000 3011333)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112670584
          :relative 1.5724991741216552
        )
        :calibrates (2911500 3118834)
      ))
    :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 117059417
          :relative 1.5895363219122791
        )
        :calibrates (2957625 3066584)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106528042
          :relative 1.5382498849202504
        )
        :calibrates (3149958 3019458)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112690959
          :relative 1.5679098060597092
        )
        :calibrates (3116333 2979166)
      ))
    :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114133458
          :relative 1.5778976244310627
        )
        :calibrates (2921792 3111375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 120179541
          :relative 1.5862767187504212
        )
        :calibrates (2880416 3350958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106052917
          :relative 1.5528697832871565
        )
        :calibrates (2941666 2996917)
      ))
    :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110939500
          :relative 1.558998336719067
        )
        :calibrates (3010166 3115000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111570125
          :relative 1.530022136016292
        )
        :calibrates (3593875 2991125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106846875
          :relative 1.560713137446149
        )
        :calibrates (2890750 2985208)
      ))
    :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111166250
          :relative 1.5594333147821156
        )
        :calibrates (3008041 3123500)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109744833
          :relative 1.5729856277060643
        )
        :calibrates (2885042 2982125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 105438458
          :relative 1.548564232212069
        )
        :calibrates (2894708 3068292)
      ))
    :"jpamb.cases.PrecisionBenchmarks.bitwiseMaskBoundSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110693250
          :relative 1.5575165518734366
        )
        :calibrates (3013125 3119333)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108634792
          :relative 1.5579288194662664
        )
        :calibrates (2888292 3124416)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106205000
          :relative 1.537212573803231
        )
        :calibrates (3190375 2975041)
      ))
    :"jpamb.cases.PrecisionBenchmarks.bitwiseOrNonZeroSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 131420917
          :relative 1.626369858854427
        )
        :calibrates (3007875 3205458)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109118833
          :relative 1.5525066148287576
        )
        :calibrates (2959417 3155958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107694292
          :relative 1.5585323971682616
        )
        :calibrates (2974000 2978375)
      ))
    :"jpamb.cases.PrecisionBenchmarks.contradictoryRangeSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 112993042
          :relative 1.4807538274800427
        )
        :calibrates (4227583 3242542)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 152447084
          :relative 1.7066015212690662
        )
        :calibrates (3005708 2985958)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107189042
          :relative 1.562431245920798
        )
        :calibrates (2879917 2991584)
      ))
    :"jpamb.cases.PrecisionBenchmarks.correlatedBranchSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 113438208
          :relative 1.559134134715345
        )
        :calibrates (3127708 3133458)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109465625
          :relative 1.569011225632589
        )
        :calibrates (2879125 3026917)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109368333
          :relative 1.5707997438529586
        )
        :calibrates (2906500 2970042)
      ))
    :"jpamb.cases.PrecisionBenchmarks.helperPassthroughLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" unknown
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 140965833
          :relative 1.6574458184738923
        )
        :calibrates (3024250 3180125)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" unknown
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 107452917
          :relative 1.5642517355891041
        )
        :calibrates (2885667 2975667)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" unknown
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 111353292
          :relative 1.5555573771619515
        )
        :calibrates (2880875 3316042)
      ))
    :"jpamb.cases.PrecisionBenchmarks.helperPassthroughSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" unknown
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 118515375
          :relative 1.5737298791394487
        )
        :calibrates (3175500 3149708)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" unknown
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 108513542
          :relative 1.5685236894738273
        )
        :calibrates (2882125 2979125)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" unknown
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 135313000
          :relative 1.640255165506426
        )
        :calibrates (3201625 2994417)
      ))
    :"jpamb.cases.PrecisionBenchmarks.intervalHullHoleSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 119481625
          :relative 1.569971036360338
        )
        :calibrates (3241333 3190875)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 117983541
          :relative 1.5920362171329339
        )
        :calibrates (3058417 2978500)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106861917
          :relative 1.5405573082794524
        )
        :calibrates (3174291 2981667)
      ))
    :"jpamb.cases.PrecisionBenchmarks.largeLoopWideningSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 116343291
          :relative 1.5771289428375497
        )
        :calibrates (3010333 3150542)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108071417
          :relative 1.5435767164747953
        )
        :calibrates (3113958 3068542)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108086333
          :relative 1.5452171053750778
        )
        :calibrates (3140084 3019958)
      ))
    :"jpamb.cases.PrecisionBenchmarks.loopExitBoundSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115244667
          :relative 1.557773386592439
        )
        :calibrates (3066250 3314584)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108305250
          :relative 1.5649011822882022
        )
        :calibrates (2875708 3023291)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109082833
          :relative 1.569153746660195
        )
        :calibrates (2874167 3009291)
      ))
    :"jpamb.cases.PrecisionBenchmarks.overflowDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 119484208
          :relative 1.5826371597053321
        )
        :calibrates (3184625 3062833)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 124459458
          :relative 1.585332677891301
        )
        :calibrates (2885208 3582125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107529167
          :relative 1.563779475335397
        )
        :calibrates (2882333 2989542)
      ))
    :"jpamb.cases.PrecisionBenchmarks.overflowPrunedBySyntacticLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114266417
          :relative 1.5781993741802518
        )
        :calibrates (2940875 3095125)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 115101209
          :relative 1.515146833945022
        )
        :calibrates (3931708 3098417)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok no
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 114150167
          :relative 1.5847018238732373
        )
        :calibrates (2883083 3057167)
      ))
    :"jpamb.cases.PrecisionBenchmarks.paritySafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111177625
          :relative 1.538001387191424
        )
        :calibrates (3181375 3261000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108099709
          :relative 1.5519998709451892
        )
        :calibrates (3038000 3027333)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 110960959
          :relative 1.5714977288267387
        )
        :calibrates (2927167 3025375)
      ))
    :"jpamb.cases.PrecisionBenchmarks.recursiveCountdownLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 239535750
          :relative 1.8657559944535784
        )
        :calibrates (3364417 3161542)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 108664208
          :relative 1.565881241674452
        )
        :calibrates (2884542 3020667)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" unknown
            :"null pointer" unknown
            :ok unknown
            :"out of bounds" unknown
          )
        )
        :duration (duration
          :absolute 209037000
          :relative 1.8499137604084812
        )
        :calibrates (2890709 3015916)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalAlwaysLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 137054958
          :relative 1.6456176826661286
        )
        :calibrates (3110084 3088708)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 108599083
          :relative 1.5673464914671327
        )
        :calibrates (2887417 2994375)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 153464584
          :relative 1.7151262206371296
        )
        :calibrates (2924292 2990125)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalOrderSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 118600083
          :relative 1.5931413012802917
        )
        :calibrates (3020042 3033000)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 109242416
          :relative 1.5667543411238165
        )
        :calibrates (2901083 3023625)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107271500
          :relative 1.5550946036379727
        )
        :calibrates (2893459 3082667)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalSelfCancelSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 166951292
          :relative 1.7121844007800362
        )
        :calibrates (3064125 3413792)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 117141125
          :relative 1.588798304989297
        )
        :calibrates (2879375 3159292)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 106784167
          :relative 1.553723181901301
        )
        :calibrates (2996834 2970958)
      ))
    :"jpamb.cases.PrecisionBenchmarks.signHoleRangeSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 152133250
          :relative 1.6904948555536266
        )
        :calibrates (3157625 3047625)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 107385083
          :relative 1.5229054369475097
        )
        :calibrates (3388167 3054542)
      ) (analysis-result
        :response (response
          :predictions (
            :* no
            :"assertion error" no
            :"divide by zero" no
            :"null pointer" no
            :ok ok-safe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111254166
          :relative 1.564885622300765
        )
        :calibrates (2971375 3088458)
      ))
    :"jpamb.cases.PrecisionBenchmarks.wideningOvershootSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 120689375
          :relative 1.5993641955166389
        )
        :calibrates (3008959 3063084)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111915875
          :relative 1.5790451673731387
        )
        :calibrates (2885708 3014625)
      ) (analysis-result
        :response (response
          :predictions (
            :* unknown
            :"assertion error" maybe
            :"divide by zero" no
            :"null pointer" no
            :ok ok-maybe
            :"out of bounds" no
          )
        )
        :duration (duration
          :absolute 111162500
          :relative 1.5689396285974289
        )
        :calibrates (3014000 2984583)
      ))
  )
)