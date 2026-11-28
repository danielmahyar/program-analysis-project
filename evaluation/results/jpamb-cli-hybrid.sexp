(analysis-summary
  :config (analysis-config
    :cmd (/Users/Bruger/Desktop/program-analysis-project/solutions/hybrid/.venv/bin/python /Users/Bruger/Desktop/program-analysis-project/solutions/hybrid/src/hybrid.py)
    :analysis (analysis-info
      :name hybrid-confidentiality
      :version 1.0
      :group LineaRIZZability
      :tags (hybrid syntactic dynamic confidentiality python)
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
    :timeout 30.0
  )
  :results (
    :"jpamb.cases.AdvancedLeaks.computedDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 135477708
          :relative 1.6446322195893683
        )
        :calibrates (3145250 2996125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125121208
          :relative 1.6196972194136794
        )
        :calibrates (2903959 3103125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127905709
          :relative 1.637276498467789
        )
        :calibrates (2939125 2958042)
      ))
    :"jpamb.cases.AdvancedLeaks.continueSkipsSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 156745333
          :relative 1.7216589667204194
        )
        :calibrates (3025083 2925584)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 149561625
          :relative 1.7107499227473275
        )
        :calibrates (2861959 2960417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 138806041
          :relative 1.6668400276681368
        )
        :calibrates (2962209 3016375)
      ))
    :"jpamb.cases.AdvancedLeaks.continueSkipsSinkSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125507708
          :relative 1.637109373363018
        )
        :calibrates (2821875 2966958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131422708
          :relative 1.6472900901322238
        )
        :calibrates (2890250 3030958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 124231625
          :relative 1.6328117562275872
        )
        :calibrates (2868500 2918459)
      ))
    :"jpamb.cases.AdvancedLeaks.doWhileLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 629323208
          :relative 2.3192084787749456
        )
        :calibrates (2870000 3165250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 678631667
          :relative 2.3445340842312237
        )
        :calibrates (3179042 2960416)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 620239459
          :relative 2.3300896667076767
        )
        :calibrates (2857500 2943458)
      ))
    :"jpamb.cases.AdvancedLeaks.earlyReturnBeforeSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok partial-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126865625
          :relative 1.6282874678107084
        )
        :calibrates (3000292 2971250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok partial-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 140427708
          :relative 1.671391437879525
        )
        :calibrates (2943125 3042250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok partial-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 243766708
          :relative 1.9156215762422042
        )
        :calibrates (2899458 3021375)
      ))
    :"jpamb.cases.AdvancedLeaks.earlyReturnSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 120172292
          :relative 1.6168139387429208
        )
        :calibrates (2810375 2997542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 141127500
          :relative 1.6594336175437268
        )
        :calibrates (3121125 3062000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121837375
          :relative 1.6030736995559345
        )
        :calibrates (3071833 3005833)
      ))
    :"jpamb.cases.AdvancedLeaks.forLoopLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 611777292
          :relative 2.3287996857924953
        )
        :calibrates (2811292 2927542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 631070084
          :relative 2.3223506303816435
        )
        :calibrates (3033083 2975291)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 621877375
          :relative 2.330624105454219
        )
        :calibrates (2889083 2920041)
      ))
    :"jpamb.cases.AdvancedLeaks.forLoopSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132016667
          :relative 1.6567295815142675
        )
        :calibrates (2834958 2985125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128943209
          :relative 1.6194513792575709
        )
        :calibrates (3149125 3044959)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 170194334
          :relative 1.7579054257883806
        )
        :calibrates (2903250 3040625)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedThresholdLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130960042
          :relative 1.6580039550859806
        )
        :calibrates (2805542 2951042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 140593750
          :relative 1.6641619100129672
        )
        :calibrates (3114916 2978125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131400500
          :relative 1.643367829112105
        )
        :calibrates (3063875 2910042)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedWhileSafe:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125591167
          :relative 1.6331055429991577
        )
        :calibrates (2828667 3017666)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 136722250
          :relative 1.6626656157669257
        )
        :calibrates (2923583 3022125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130596292
          :relative 1.657311880012743
        )
        :calibrates (2817875 2931875)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedWhileWeirdCaseLeak:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 206309125
          :relative 1.8448375529851961
        )
        :calibrates (2823208 3074875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 206757042
          :relative 1.8371253076792955
        )
        :calibrates (2964709 3052083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 202172833
          :relative 1.8379883424803403
        )
        :calibrates (2870000 3001708)
      ))
    :"jpamb.cases.AdvancedLeaks.overwrittenAfterBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 205239625
          :relative 1.8116846003264329
        )
        :calibrates (3049417 3283541)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125640125
          :relative 1.620859551721021
        )
        :calibrates (2860750 3155125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 119815667
          :relative 1.607809180039852
        )
        :calibrates (2924000 2988000)
      ))
    :"jpamb.cases.AdvancedLeaks.ternaryDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132037125
          :relative 1.6393639535111468
        )
        :calibrates (3075833 2982625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126127500
          :relative 1.6175583607460535
        )
        :calibrates (2942750 3142542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124635916
          :relative 1.629610147306652
        )
        :calibrates (2876750 2972000)
      ))
    :"jpamb.cases.AdvancedLeaks.ternaryImplicitLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 144985833
          :relative 1.678318073856664
        )
        :calibrates (2806750 3275125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131344083
          :relative 1.6612354111879089
        )
        :calibrates (2816291 2914375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129532459
          :relative 1.6428050963723
        )
        :calibrates (2886500 3010125)
      ))
    :"jpamb.cases.AdvancedLeaks.tripleNestedWhileCornerLeak:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 205903000
          :relative 1.8174857406673697
        )
        :calibrates (3329666 2939459)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 194890375
          :relative 1.8279793869366225
        )
        :calibrates (2817208 2974958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 196205459
          :relative 1.8251307263725718
        )
        :calibrates (2908459 2961166)
      ))
    :"jpamb.cases.BasicLeaks.explicitArithmetic:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126005959
          :relative 1.6393743149425866
        )
        :calibrates (2837791 2943792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138591917
          :relative 1.6418561863361407
        )
        :calibrates (2812125 3510708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127661958
          :relative 1.6480598494057044
        )
        :calibrates (2809917 2931666)
      ))
    :"jpamb.cases.BasicLeaks.explicitConstantSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 120686583
          :relative 1.6228921570695474
        )
        :calibrates (2818708 2933000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 178895584
          :relative 1.7626001728873277
        )
        :calibrates (3002125 3178458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121376500
          :relative 1.6231772625218526
        )
        :calibrates (2810167 2970625)
      ))
    :"jpamb.cases.BasicLeaks.explicitCopy:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125050125
          :relative 1.6299664548928912
        )
        :calibrates (2919667 2943708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130390292
          :relative 1.6404798420546685
        )
        :calibrates (2983708 2983833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133517666
          :relative 1.6625513921065986
        )
        :calibrates (2821917 2985959)
      ))
    :"jpamb.cases.BasicLeaks.explicitDirect:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129380166
          :relative 1.6550053252259391
        )
        :calibrates (2809958 2916583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131968708
          :relative 1.6376777474794757
        )
        :calibrates (2938542 3140333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124793167
          :relative 1.6185721351458915
        )
        :calibrates (3017917 2988959)
      ))
    :"jpamb.cases.BasicLeaks.explicitDirectSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123653792
          :relative 1.6129891974958603
        )
        :calibrates (2996500 3032541)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130388417
          :relative 1.6329253011544849
        )
        :calibrates (2996167 3076000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 120073000
          :relative 1.6144097125909604
        )
        :calibrates (2808750 3026583)
      ))
    :"jpamb.cases.BasicLeaks.explicitMixed:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124557417
          :relative 1.6298286697876294
        )
        :calibrates (2912167 2929959)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134931333
          :relative 1.6423176904151333
        )
        :calibrates (3211625 2937667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132914250
          :relative 1.6389307403870814
        )
        :calibrates (2899083 3205708)
      ))
    :"jpamb.cases.BasicLeaks.explicitMixedSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128863334
          :relative 1.64465349066573
        )
        :calibrates (2829959 3011292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125812042
          :relative 1.6360251466957616
        )
        :calibrates (2844500 2972875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 142874875
          :relative 1.6863347479297066
        )
        :calibrates (2904417 2979291)
      ))
    :"jpamb.cases.BasicLeaks.explicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 122783917
          :relative 1.6314424228089812
        )
        :calibrates (2809542 2928042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 138195875
          :relative 1.6540911697312453
        )
        :calibrates (2944875 3184750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125120416
          :relative 1.6267922259880703
        )
        :calibrates (2909541 3000166)
      ))
    :"jpamb.cases.BasicLeaks.explicitReturnSafe:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 120382208
          :relative 1.6169896327243738
        )
        :calibrates (2835417 2980292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 147528042
          :relative 1.6678810134015387
        )
        :calibrates (3107208 3231833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 117910083
          :relative 1.6112327235688355
        )
        :calibrates (2844958 2927333)
      ))
    :"jpamb.cases.BasicLeaks.implicitAfterBranchSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121180916
          :relative 1.6081717476944686
        )
        :calibrates (2990792 2983583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123483750
          :relative 1.6186888861707982
        )
        :calibrates (2870750 3071500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 118986334
          :relative 1.6150189363791865
        )
        :calibrates (2859833 2914584)
      ))
    :"jpamb.cases.BasicLeaks.implicitIf:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128274792
          :relative 1.6470493645610513
        )
        :calibrates (2808542 2974042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131839042
          :relative 1.640711638494131
        )
        :calibrates (2975667 3054959)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130954666
          :relative 1.656329617300244
        )
        :calibrates (2815666 2962917)
      ))
    :"jpamb.cases.BasicLeaks.implicitIfElse:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130120833
          :relative 1.6433303130478656
        )
        :calibrates (2854667 3061583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132245916
          :relative 1.6526872729922821
        )
        :calibrates (2927000 2957709)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123802292
          :relative 1.6262751016230728
        )
        :calibrates (2874708 2979708)
      ))
    :"jpamb.cases.BasicLeaks.implicitIfSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 149759000
          :relative 1.6936577185769688
        )
        :calibrates (3060417 3003667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121669334
          :relative 1.6269683430114767
        )
        :calibrates (2808125 2936250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121518917
          :relative 1.6004211629240552
        )
        :calibrates (2860042 3238875)
      ))
    :"jpamb.cases.BasicLeaks.implicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131431250
          :relative 1.6574128088694862
        )
        :calibrates (2837583 2947583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 124948000
          :relative 1.637509593131244
        )
        :calibrates (2832167 2925542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127694250
          :relative 1.6200657487252064
        )
        :calibrates (3002708 3122708)
      ))
    :"jpamb.cases.BasicLeaks.implicitSinkInBranch:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125843500
          :relative 1.6360933376421072
        )
        :calibrates (2843916 2974000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 134014250
          :relative 1.656709836829728
        )
        :calibrates (2819417 3089000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 124712584
          :relative 1.618605065895302
        )
        :calibrates (3029750 2972792)
      ))
    :"jpamb.cases.BasicLeaks.implicitWhile:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 619247917
          :relative 2.325778923042936
        )
        :calibrates (2828416 3021042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 622581000
          :relative 2.2968860276369067
        )
        :calibrates (3223042 3062458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 607205458
          :relative 2.309763597809666
        )
        :calibrates (2983041 2968125)
      ))
    :"jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 136996458
          :relative 1.6597238222715178
        )
        :calibrates (2999208 2998917)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 159379334
          :relative 1.7341677772965767
        )
        :calibrates (2917583 2961292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132558333
          :relative 1.6435250319825354
        )
        :calibrates (2898625 3125750)
      ))
    :"jpamb.cases.BasicLeaks.skippedLoop:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126652916
          :relative 1.6369937684666729
        )
        :calibrates (2889250 2953959)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125582167
          :relative 1.6340907861831102
        )
        :calibrates (2928709 2903958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123574792
          :relative 1.6133874164695916
        )
        :calibrates (3069209 2950458)
      ))
    :"jpamb.cases.BasicLeaks.staticFlagsButDynamicDoesnt:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121896166
          :relative 1.6289854925386904
        )
        :calibrates (2807833 2920583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 137139917
          :relative 1.6681492262779376
        )
        :calibrates (2823292 3065750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 122290333
          :relative 1.6057553999400889
        )
        :calibrates (3048959 3013750)
      ))
    :"jpamb.cases.Clearance.flowDownOneLevel:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122732208
          :relative 1.6244286872813438
        )
        :calibrates (2840583 2987958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 137184500
          :relative 1.6402687724590088
        )
        :calibrates (3367584 2913958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 120526833
          :relative 1.6215341555592644
        )
        :calibrates (2809042 2953042)
      ))
    :"jpamb.cases.Clearance.flowUpTwoLevels:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 119229000
          :relative 1.594631864007337
        )
        :calibrates (3082708 2981583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129581125
          :relative 1.643579379289991
        )
        :calibrates (2824958 3063375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 117599125
          :relative 1.6122826411402416
        )
        :calibrates (2829417 2913750)
      ))
    :"jpamb.cases.Clearance.joinBecomesSecret:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124404584
          :relative 1.6312263748917255
        )
        :calibrates (2904875 2911334)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130766667
          :relative 1.6459609538691409
        )
        :calibrates (2907709 3002000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 121641167
          :relative 1.6235852026624638
        )
        :calibrates (2812083 2975875)
      ))
    :"jpamb.cases.Clearance.joinStaysConfidential:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121758333
          :relative 1.6036948765091494
        )
        :calibrates (2849458 3215584)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 122797000
          :relative 1.6086269384739338
        )
        :calibrates (3037250 3010458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 142448875
          :relative 1.6859800458741203
        )
        :calibrates (2876333 2994625)
      ))
    :"jpamb.cases.Clearance.nestedBranches:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131372750
          :relative 1.6380701607723456
        )
        :calibrates (3090208 2955750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129851666
          :relative 1.6504944353407212
        )
        :calibrates (2816209 2991209)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129449333
          :relative 1.644867942314871
        )
        :calibrates (2872625 2992292)
      ))
    :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 181559000
          :relative 1.7960305170230273
        )
        :calibrates (2839542 2968333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 191954250
          :relative 1.8071363624807002
        )
        :calibrates (2964334 3021041)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 185797458
          :relative 1.786163184211125
        )
        :calibrates (3018875 3061167)
      ))
    :"jpamb.cases.Clearance.sequentialBranches:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128572167
          :relative 1.646717742663647
        )
        :calibrates (2838500 2961917)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 187832917
          :relative 1.7704123292239726
        )
        :calibrates (3017375 3356292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121889334
          :relative 1.5952583262375861
        )
        :calibrates (3145416 3045250)
      ))
    :"jpamb.cases.Clearance.topSecretBroadcast:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122741708
          :relative 1.630766748997574
        )
        :calibrates (2822875 2921667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 139079709
          :relative 1.6184945390066974
        )
        :calibrates (3659500 3036250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123012583
          :relative 1.6277043935731597
        )
        :calibrates (2821125 2976834)
      ))
    :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128776833
          :relative 1.6422758040919645
        )
        :calibrates (2881209 2988167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 133492583
          :relative 1.6476458296500376
        )
        :calibrates (3051625 2957916)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131619750
          :relative 1.655810673911847
        )
        :calibrates (2894000 2920875)
      ))
    :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128042041
          :relative 1.6441939685045792
        )
        :calibrates (2840375 2969792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 135726375
          :relative 1.6522320649414453
        )
        :calibrates (2844333 3201584)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128455875
          :relative 1.6476651715773605
        )
        :calibrates (2809250 2973292)
      ))
    :"jpamb.cases.Compartments.implicitWithinSink:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 120764833
          :relative 1.5913675414574704
        )
        :calibrates (2882583 3306167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123592125
          :relative 1.6253641088531212
        )
        :calibrates (2894250 2962500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123866750
          :relative 1.6151855699500475
        )
        :calibrates (2911958 3097000)
      ))
    :"jpamb.cases.Compartments.incomparableSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127553833
          :relative 1.633397338667936
        )
        :calibrates (2916292 3017416)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127243166
          :relative 1.623765614538391
        )
        :calibrates (3004208 3047791)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127882750
          :relative 1.6390743320445307
        )
        :calibrates (2901042 2970709)
      ))
    :"jpamb.cases.Compartments.joinIsLeastUpperBound:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123789542
          :relative 1.6247306977243399
        )
        :calibrates (2883417 2991250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128677875
          :relative 1.6268446396209346
        )
        :calibrates (3052375 3024625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128043959
          :relative 1.639193348115898
        )
        :calibrates (2812875 3064667)
      ))
    :"jpamb.cases.Compartments.joinOfThree:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126176625
          :relative 1.6110145242048948
        )
        :calibrates (3218667 2961417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134037292
          :relative 1.66195740595504
        )
        :calibrates (2816209 3022250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 153892542
          :relative 1.7172053927943947
        )
        :calibrates (2908417 2994167)
      ))
    :"jpamb.cases.Compartments.joinOfThreeToTop:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125256625
          :relative 1.6258127011043377
        )
        :calibrates (3013666 2915833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130746709
          :relative 1.646783533645198
        )
        :calibrates (2879084 3018542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 119456208
          :relative 1.6153289692466821
        )
        :calibrates (2821333 2971750)
      ))
    :"jpamb.cases.Compartments.joinOfTwo:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121252708
          :relative 1.6154334217405761
        )
        :calibrates (2925083 2953708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 119097791
          :relative 1.6190760631594923
        )
        :calibrates (2823375 2902708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121626459
          :relative 1.6184631461224814
        )
        :calibrates (2886834 2969083)
      ))
    :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 162193083
          :relative 1.7484306433114454
        )
        :calibrates (2833583 2955792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 157768583
          :relative 1.72174145945162
        )
        :calibrates (2809667 3178709)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 156380292
          :relative 1.7250690711571768
        )
        :calibrates (2866125 3024250)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget19:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127814667
          :relative 1.6460304999558886
        )
        :calibrates (2818875 2956500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125580208
          :relative 1.6391549707454443
        )
        :calibrates (2829792 2935167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134084333
          :relative 1.654338437065802
        )
        :calibrates (2865458 3078416)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget23:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133553583
          :relative 1.6414150146638788
        )
        :calibrates (2867000 3232167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124668958
          :relative 1.635029579028461
        )
        :calibrates (2806666 2971084)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 139319167
          :relative 1.6732666259912579
        )
        :calibrates (2931500 2981042)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget31:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126950000
          :relative 1.618461591660795
        )
        :calibrates (3056917 3055333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126548375
          :relative 1.6383543308840869
        )
        :calibrates (2889291 2930833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132169875
          :relative 1.6135042672082724
        )
        :calibrates (2895750 3540875)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTargetSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 121927250
          :relative 1.6300036813491587
        )
        :calibrates (2808500 2907959)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124737459
          :relative 1.619660465569305
        )
        :calibrates (2864042 3125125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 157825375
          :relative 1.7036512257383543
        )
        :calibrates (3250333 2995000)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair17:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 137319000
          :relative 1.6698451697296564
        )
        :calibrates (2855583 3018167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 160282333
          :relative 1.734711046948854
        )
        :calibrates (2907500 2997292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131135000
          :relative 1.6568521112774979
        )
        :calibrates (2810125 2969458)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair29:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134880959
          :relative 1.6615818220881526
        )
        :calibrates (2970875 2909416)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131902666
          :relative 1.6548210487829973
        )
        :calibrates (2866084 2974584)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130636708
          :relative 1.633781341971009
        )
        :calibrates (3048875 3022875)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair53:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129283583
          :relative 1.6426947581794007
        )
        :calibrates (2913333 2973458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130911250
          :relative 1.6398104783488148
        )
        :calibrates (2986042 3014583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130720958
          :relative 1.6544216877932707
        )
        :calibrates (2814792 2978875)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePairSafe:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 121158084
          :relative 1.6056766126342388
        )
        :calibrates (3051833 2955833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122583709
          :relative 1.6287795452429126
        )
        :calibrates (2815750 2947709)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 121998000
          :relative 1.613422651743364
        )
        :calibrates (2905333 3037042)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget1031:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132945791
          :relative 1.6548873553980328
        )
        :calibrates (2812125 3073834)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129709459
          :relative 1.6269694401089922
        )
        :calibrates (3061333 3062625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 135569292
          :relative 1.668900017585265
        )
        :calibrates (2856333 2955208)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget257:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 190059333
          :relative 1.8083102585901891
        )
        :calibrates (2988167 2922125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130375458
          :relative 1.6455916218204143
        )
        :calibrates (2917292 2979750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 137722416
          :relative 1.6659679564871768
        )
        :calibrates (2878542 3065292)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget509:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131615250
          :relative 1.6487670993826569
        )
        :calibrates (2864750 3045000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134405083
          :relative 1.655309025201726
        )
        :calibrates (2873000 3071792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 173660500
          :relative 1.7794110406832813
        )
        :calibrates (2810333 2961583)
      ))
    :"jpamb.cases.FuzzingChallenges.productTargetSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129318250
          :relative 1.6345234365059385
        )
        :calibrates (2916167 3084042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 180693708
          :relative 1.7862049570820804
        )
        :calibrates (2914708 2997750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 119255750
          :relative 1.610248348797397
        )
        :calibrates (2915333 2936083)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask3:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 142119584
          :relative 1.669944092438868
        )
        :calibrates (2991333 3086375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130979917
          :relative 1.646200448225934
        )
        :calibrates (2980792 2935291)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126378667
          :relative 1.641967211177191
        )
        :calibrates (2806833 2957334)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask4:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131057042
          :relative 1.652015568076263
        )
        :calibrates (2854541 2986292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124994916
          :relative 1.63518130405479
        )
        :calibrates (2809208 2981625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124894042
          :relative 1.6310101641208383
        )
        :calibrates (2862292 2979708)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask5:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 135641792
          :relative 1.6602070709620773
        )
        :calibrates (2953792 2978417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124875875
          :relative 1.6317593167519866
        )
        :calibrates (2843958 2987125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127759709
          :relative 1.6408344803413815
        )
        :calibrates (2863375 2979000)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMaskSafe:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 136083209
          :relative 1.6573049902090586
        )
        :calibrates (3053042 2938375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 118354708
          :relative 1.608882401911813
        )
        :calibrates (2867166 2958333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122195959
          :relative 1.615502288367811
        )
        :calibrates (2908292 3015292)
      ))
    :"jpamb.cases.Hospital.adminCombinesDepartments:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 138827917
          :relative 1.6622602457889313
        )
        :calibrates (2978666 3064250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121689125
          :relative 1.6159484181808497
        )
        :calibrates (2860708 3032250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128201667
          :relative 1.6136172980560566
        )
        :calibrates (2971875 3269875)
      ))
    :"jpamb.cases.Hospital.combinedToOneDepartment:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 140255000
          :relative 1.6685894131547852
        )
        :calibrates (2867125 3149583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127049791
          :relative 1.605792743676717
        )
        :calibrates (2957583 3340541)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 140465333
          :relative 1.6723066698186582
        )
        :calibrates (2950416 3023959)
      ))
    :"jpamb.cases.Hospital.compartmentLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133826541
          :relative 1.6472729424168926
        )
        :calibrates (3122125 2907625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126498292
          :relative 1.6210901035081007
        )
        :calibrates (2858209 3195542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122773958
          :relative 1.616547844219379
        )
        :calibrates (2994875 2942417)
      ))
    :"jpamb.cases.Hospital.deadBranchLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128286958
          :relative 1.649447160431177
        )
        :calibrates (2828916 2922375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125487458
          :relative 1.6144132713556936
        )
        :calibrates (3080541 3017875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 120653500
          :relative 1.6229524567980194
        )
        :calibrates (2829917 2919416)
      ))
    :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 133337708
          :relative 1.6624613249511746
        )
        :calibrates (2851834 2949417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128062250
          :relative 1.6303752298373306
        )
        :calibrates (2950375 3048584)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129365708
          :relative 1.6493212955415453
        )
        :calibrates (2847500 2953834)
      ))
    :"jpamb.cases.Hospital.oncologyOnly:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129790542
          :relative 1.6443605633302467
        )
        :calibrates (2927125 2960125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 121420000
          :relative 1.6180560578371368
        )
        :calibrates (2917292 2934167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123485292
          :relative 1.6277377655006942
        )
        :calibrates (2828500 2991292)
      ))
    :"jpamb.cases.Hospital.process:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134619167
          :relative 1.6440039306372174
        )
        :calibrates (3004750 3106541)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125927750
          :relative 1.6381729485172478
        )
        :calibrates (2817291 2976709)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126269459
          :relative 1.6339523496514197
        )
        :calibrates (2873375 2993083)
      ))
    :"jpamb.cases.Hospital.psychSessionCount:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 662345000
          :relative 2.350722804869114
        )
        :calibrates (2996791 2910542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 624002417
          :relative 2.3332814781586535
        )
        :calibrates (2829459 2963958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 621248750
          :relative 2.33182012816433
        )
        :calibrates (2822333 2964959)
      ))
    :"jpamb.cases.Hospital.publicRiskScore:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 133472958
          :relative 1.6664408189572482
        )
        :calibrates (2818167 2936000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121312375
          :relative 1.613114956358726
        )
        :calibrates (2890625 3022542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121055167
          :relative 1.6158934326522016
        )
        :calibrates (2882416 2980584)
      ))
    :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129366834
          :relative 1.608245041439198
        )
        :calibrates (3128875 3248000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122673292
          :relative 1.6252676407518607
        )
        :calibrates (2857500 2957000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128405791
          :relative 1.642718652159895
        )
        :calibrates (2868125 2978375)
      ))
    :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126342375
          :relative 1.6026156136591854
        )
        :calibrates (3064375 3244667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 119314417
          :relative 1.610248538826916
        )
        :calibrates (2876667 2977625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 120331542
          :relative 1.6149904583044339
        )
        :calibrates (2809958 3030125)
      ))
    :"jpamb.cases.InfoFlow.explicitLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 156771833
          :relative 1.7223775904294172
        )
        :calibrates (3003333 2938500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122404500
          :relative 1.6170164895568135
        )
        :calibrates (2862250 3050791)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122233041
          :relative 1.6228418702857506
        )
        :calibrates (2859750 2966334)
      ))
    :"jpamb.cases.InfoFlow.explicitSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125383125
          :relative 1.6220174662917353
        )
        :calibrates (3006084 2981500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 119950875
          :relative 1.6186131270005655
        )
        :calibrates (2823333 2949916)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128562125
          :relative 1.6279601833889927
        )
        :calibrates (2934083 3121875)
      ))
    :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132891042
          :relative 1.6409675531577783
        )
        :calibrates (3013958 3061208)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131430000
          :relative 1.6511880701960946
        )
        :calibrates (2806834 3061792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 144572834
          :relative 1.676998873596061
        )
        :calibrates (3047166 3035834)
      ))
    :"jpamb.cases.InfoFlow.implicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 143155167
          :relative 1.6859881035569921
        )
        :calibrates (2861875 3038083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 158683000
          :relative 1.7146079839143535
        )
        :calibrates (3191708 2931125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 124434500
          :relative 1.6318600810566293
        )
        :calibrates (2860542 2948583)
      ))
    :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130525417
          :relative 1.6508859002114105
        )
        :calibrates (2911208 2921083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133813417
          :relative 1.6550703471354988
        )
        :calibrates (2934084 2987792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125909875
          :relative 1.6311035476880076
        )
        :calibrates (2922000 2966250)
      ))
    :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 615420917
          :relative 2.3263439178308745
        )
        :calibrates (2819667 2986083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 612488083
          :relative 2.320532726308039
        )
        :calibrates (2851084 3004833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 632181958
          :relative 2.32971239650064
        )
        :calibrates (2924875 2992917)
      ))
    :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 122345625
          :relative 1.6271008950913575
        )
        :calibrates (2813834 2960708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123318708
          :relative 1.6158179523273464
        )
        :calibrates (2961792 3011875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125122958
          :relative 1.6296764447956247
        )
        :calibrates (2868875 3001834)
      ))
    :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128839875
          :relative 1.6467795685591586
        )
        :calibrates (2864917 2946750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 117354709
          :relative 1.6080895671348758
        )
        :calibrates (2858875 2927958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 116291125
          :relative 1.5996001727102118
        )
        :calibrates (2887750 2959833)
      ))
    :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132899625
          :relative 1.6600601243176878
        )
        :calibrates (2883541 2930708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127450334
          :relative 1.6407799730256518
        )
        :calibrates (2806375 3022584)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-safe
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok confirmed-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121134042
          :relative 1.6114704367597634
        )
        :calibrates (2866500 3060375)
      ))
    :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129380375
          :relative 1.634045030249722
        )
        :calibrates (2939083 3070625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 120772542
          :relative 1.6104626295854272
        )
        :calibrates (2964708 2958208)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok partial-ok
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126537542
          :relative 1.6223742630748164
        )
        :calibrates (3028500 3009250)
      ))
    :"jpamb.cases.PrecisionBenchmarks.bitwiseMaskBoundSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132852333
          :relative 1.6355182041119019
        )
        :calibrates (3209250 2940833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129938125
          :relative 1.646430751707104
        )
        :calibrates (2864208 3001708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 135308584
          :relative 1.658139570051221
        )
        :calibrates (2995125 2950750)
      ))
    :"jpamb.cases.PrecisionBenchmarks.bitwiseOrNonZeroSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128526250
          :relative 1.6414423311826178
        )
        :calibrates (2849333 3019875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127036375
          :relative 1.6399325118041563
        )
        :calibrates (2892708 2928667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130044625
          :relative 1.6529285085522907
        )
        :calibrates (2808875 2974667)
      ))
    :"jpamb.cases.PrecisionBenchmarks.contradictoryRangeSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130659625
          :relative 1.6496970227212857
        )
        :calibrates (2886334 2967958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127235167
          :relative 1.6449163522342494
        )
        :calibrates (2851958 2912000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 140583667
          :relative 1.6767990754184887
        )
        :calibrates (2829667 3088208)
      ))
    :"jpamb.cases.PrecisionBenchmarks.correlatedBranchSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133963250
          :relative 1.6557947731887532
        )
        :calibrates (2859584 3059042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132717667
          :relative 1.654839993939914
        )
        :calibrates (2876625 2999875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 159733291
          :relative 1.7335213113733428
        )
        :calibrates (2921083 2979625)
      ))
    :"jpamb.cases.PrecisionBenchmarks.helperPassthroughLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133083167
          :relative 1.6583407451457315
        )
        :calibrates (2902875 2942500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 176938458
          :relative 1.7863049533431918
        )
        :calibrates (2837834 2950416)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127463625
          :relative 1.643712720527889
        )
        :calibrates (2866250 2924083)
      ))
    :"jpamb.cases.PrecisionBenchmarks.helperPassthroughSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 154654709
          :relative 1.7175276624231766
        )
        :calibrates (2844375 3083042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 183228000
          :relative 1.6986464684963158
        )
        :calibrates (2885416 4449166)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126663500
          :relative 1.6360124104997027
        )
        :calibrates (2859125 2997792)
      ))
    :"jpamb.cases.PrecisionBenchmarks.intervalHullHoleSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 140293625
          :relative 1.6584226451040844
        )
        :calibrates (2984041 3176875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 140595000
          :relative 1.580811064418967
        )
        :calibrates (4246959 3135292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130587834
          :relative 1.652482561888807
        )
        :calibrates (2847000 2966667)
      ))
    :"jpamb.cases.PrecisionBenchmarks.largeLoopWideningSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* timeout
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 1952012042
          :relative 2.8051071492455892
        )
        :calibrates (3211542 2903583)
      ) (analysis-result
        :response (response
          :predictions (
            :* timeout
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 1988113666
          :relative 2.821241572797424
        )
        :calibrates (3033166 2967917)
      ) (analysis-result
        :response (response
          :predictions (
            :* timeout
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 1951789167
          :relative 2.8237196849430393
        )
        :calibrates (2812959 3044958)
      ))
    :"jpamb.cases.PrecisionBenchmarks.loopExitBoundSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 209200750
          :relative 1.8539705099348165
        )
        :calibrates (2833625 3022667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 189382791
          :relative 1.809575216437216
        )
        :calibrates (2937500 2934625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 187309125
          :relative 1.8087716970024303
        )
        :calibrates (2862833 2955750)
      ))
    :"jpamb.cases.PrecisionBenchmarks.overflowDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128877209
          :relative 1.622304521638254
        )
        :calibrates (3236500 2913875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 118551833
          :relative 1.6137185016606068
        )
        :calibrates (2825125 2945459)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 119215833
          :relative 1.6083621980134042
        )
        :calibrates (2887959 2986958)
      ))
    :"jpamb.cases.PrecisionBenchmarks.overflowPrunedBySyntacticLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 137213166
          :relative 1.660790561613104
        )
        :calibrates (2862916 3129959)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133530417
          :relative 1.6505055282606467
        )
        :calibrates (2915625 3056167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132038958
          :relative 1.643801076808011
        )
        :calibrates (2864458 3132500)
      ))
    :"jpamb.cases.PrecisionBenchmarks.paritySafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 137581042
          :relative 1.6650320651443806
        )
        :calibrates (2997500 2953042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134880917
          :relative 1.6585854444626342
        )
        :calibrates (2936042 2984958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138092167
          :relative 1.6691249962127772
        )
        :calibrates (2934875 2981750)
      ))
    :"jpamb.cases.PrecisionBenchmarks.recursiveCountdownLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok partial-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134171959
          :relative 1.6451068004831748
        )
        :calibrates (2996583 3078958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok partial-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126657333
          :relative 1.6348527657908725
        )
        :calibrates (2908750 2963541)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok partial-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132006542
          :relative 1.6521250176449949
        )
        :calibrates (2874667 3007000)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalAlwaysLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 136987500
          :relative 1.6524671136564144
        )
        :calibrates (3163167 2935625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127746375
          :relative 1.6424152281122044
        )
        :calibrates (2886291 2934250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" confirmed-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129630709
          :relative 1.6399728698413052
        )
        :calibrates (2870166 3069541)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalOrderSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 151739875
          :relative 1.6740763485753536
        )
        :calibrates (2866750 3560917)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 141281958
          :relative 1.670724419858785
        )
        :calibrates (2932666 3098375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129554083
          :relative 1.6518915121472748
        )
        :calibrates (2863250 2912250)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalSelfCancelSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 261788125
          :relative 1.9373082720509387
        )
        :calibrates (3022375 3026459)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127948375
          :relative 1.6353092058530596
        )
        :calibrates (2912042 3013875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129052167
          :relative 1.6344802891486567
        )
        :calibrates (2967625 3020833)
      ))
    :"jpamb.cases.PrecisionBenchmarks.signHoleRangeSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 139283417
          :relative 1.6581188069445612
        )
        :calibrates (2933459 3187375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127950041
          :relative 1.6399382347958225
        )
        :calibrates (2894833 2968333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128943000
          :relative 1.638989871695263
        )
        :calibrates (2885500 3036084)
      ))
    :"jpamb.cases.PrecisionBenchmarks.wideningOvershootSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 179909417
          :relative 1.7826265825621943
        )
        :calibrates (2974250 2961250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 176750959
          :relative 1.7707052506181575
        )
        :calibrates (2931416 3062167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" syntactic-deep-leak
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok confirmed-ok
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 176935666
          :relative 1.7697270930599187
        )
        :calibrates (2832625 3180750)
      ))
  )
)