(analysis-summary
  :config (analysis-config
    :cmd (/Users/Bruger/Desktop/program-analysis-project/solutions/dynamic/.venv/bin/python /Users/Bruger/Desktop/program-analysis-project/solutions/dynamic/src/dynamic.py)
    :analysis (analysis-info
      :name dynamic
      :version 2.0
      :group LineaRIZZability
      :tags (dynamic python)
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
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 144087166
          :relative 1.6660249725511218
        )
        :calibrates (3174958 3042750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 137296125
          :relative 1.6681369145945926
        )
        :calibrates (2900917 2995000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138238708
          :relative 1.6655247369152275
        )
        :calibrates (3008625 2963583)
      ))
    :"jpamb.cases.AdvancedLeaks.continueSkipsSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 151297416
          :relative 1.6741785173037864
        )
        :calibrates (3425958 2981459)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 158335834
          :relative 1.7158165943998667
        )
        :calibrates (3016209 3076250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 140318958
          :relative 1.6689287658301406
        )
        :calibrates (2994292 3020458)
      ))
    :"jpamb.cases.AdvancedLeaks.continueSkipsSinkSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 143924584
          :relative 1.6895999418849719
        )
        :calibrates (2890542 2992000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 141234042
          :relative 1.6656010338600853
        )
        :calibrates (3083708 3016833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 138186500
          :relative 1.6750269951326053
        )
        :calibrates (2874583 2966167)
      ))
    :"jpamb.cases.AdvancedLeaks.doWhileLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 697743083
          :relative 2.370178206729452
        )
        :calibrates (2902875 3047541)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 677402292
          :relative 2.363830769227638
        )
        :calibrates (2875792 2986209)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 673208500
          :relative 2.3531354973702
        )
        :calibrates (2867834 3103125)
      ))
    :"jpamb.cases.AdvancedLeaks.earlyReturnBeforeSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 142407958
          :relative 1.6820408533558306
        )
        :calibrates (2932292 2990458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126601500
          :relative 1.6316211613179825
        )
        :calibrates (2885458 3028084)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129329291
          :relative 1.6401669026021024
        )
        :calibrates (2884166 3039083)
      ))
    :"jpamb.cases.AdvancedLeaks.earlyReturnSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126484417
          :relative 1.6287051861274169
        )
        :calibrates (2904625 3043250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125067542
          :relative 1.6315821332481986
        )
        :calibrates (2874333 2968083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131497625
          :relative 1.6500877314532838
        )
        :calibrates (2867916 3018625)
      ))
    :"jpamb.cases.AdvancedLeaks.forLoopLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 731257708
          :relative 2.397187421589849
        )
        :calibrates (2880208 2980000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 702106000
          :relative 2.373567060335324
        )
        :calibrates (2877208 3063875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 698250833
          :relative 2.3779505554950826
        )
        :calibrates (2864375 2984750)
      ))
    :"jpamb.cases.AdvancedLeaks.forLoopSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 680929541
          :relative 2.34188066956445
        )
        :calibrates (2925291 3272708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 674095834
          :relative 2.3451938250653686
        )
        :calibrates (2907375 3181791)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 669709916
          :relative 2.3600114114387254
        )
        :calibrates (2879292 2967334)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedThresholdLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132481333
          :relative 1.6335364367435732
        )
        :calibrates (3175958 2985000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 164630416
          :relative 1.720613242344481
        )
        :calibrates (3100083 3165000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131176333
          :relative 1.6510743627442381
        )
        :calibrates (2866666 2992167)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedWhileSafe:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 237908541
          :relative 1.8654239828159782
        )
        :calibrates (2934750 3551834)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 237790833
          :relative 1.8984048317806284
        )
        :calibrates (3019917 2989333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 229299541
          :relative 1.889438712290369
        )
        :calibrates (2881208 3034333)
      ))
    :"jpamb.cases.AdvancedLeaks.nestedWhileWeirdCaseLeak:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 238176333
          :relative 1.889609949535515
        )
        :calibrates (3075792 3066333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 237939875
          :relative 1.8886868695917935
        )
        :calibrates (2968375 3180708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 244255167
          :relative 1.912157393021324
        )
        :calibrates (2887125 3093084)
      ))
    :"jpamb.cases.AdvancedLeaks.overwrittenAfterBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132976625
          :relative 1.6404762795823549
        )
        :calibrates (2888709 3197250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 144007958
          :relative 1.672499469333867
        )
        :calibrates (2975500 3146834)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132483917
          :relative 1.6381956473689396
        )
        :calibrates (2994459 3100875)
      ))
    :"jpamb.cases.AdvancedLeaks.ternaryDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138489500
          :relative 1.6670579307158901
        )
        :calibrates (2967375 2994583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 139823458
          :relative 1.6657559116375065
        )
        :calibrates (3027083 3010375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138216916
          :relative 1.6541365999537532
        )
        :calibrates (3046250 3083667)
      ))
    :"jpamb.cases.AdvancedLeaks.ternaryImplicitLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 135682250
          :relative 1.6572726934101685
        )
        :calibrates (2904791 3069417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 158418000
          :relative 1.6686769548635534
        )
        :calibrates (2877334 3917167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127820167
          :relative 1.628884417062096
        )
        :calibrates (2988083 3020125)
      ))
    :"jpamb.cases.AdvancedLeaks.tripleNestedWhileCornerLeak:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 264361417
          :relative 1.951661970412739
        )
        :calibrates (2891542 3018167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 234502417
          :relative 1.8646299787117289
        )
        :calibrates (3317041 3088375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 218651458
          :relative 1.8686043302955928
        )
        :calibrates (2935875 2982167)
      ))
    :"jpamb.cases.BasicLeaks.explicitArithmetic:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 196890791
          :relative 1.7780482556568356
        )
        :calibrates (2900708 3663875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125015000
          :relative 1.6297363966574372
        )
        :calibrates (2882167 2982667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122125333
          :relative 1.6122435107417719
        )
        :calibrates (2882875 3081875)
      ))
    :"jpamb.cases.BasicLeaks.explicitConstantSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 148920833
          :relative 1.5685921689106057
        )
        :calibrates (5068958 2973583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125408917
          :relative 1.627226311402098
        )
        :calibrates (2902375 3015041)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125336625
          :relative 1.6224400710317939
        )
        :calibrates (3005875 2973667)
      ))
    :"jpamb.cases.BasicLeaks.explicitCopy:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 136437708
          :relative 1.6637833590362316
        )
        :calibrates (2877125 3040958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122144542
          :relative 1.619682327390872
        )
        :calibrates (2878583 2985792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130106166
          :relative 1.629283750342226
        )
        :calibrates (2968708 3141333)
      ))
    :"jpamb.cases.BasicLeaks.explicitDirect:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124539541
          :relative 1.6213248937190925
        )
        :calibrates (2926541 3030250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128436583
          :relative 1.6028945188636023
        )
        :calibrates (2882917 3526584)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123821209
          :relative 1.6139701369085429
        )
        :calibrates (3014833 3008750)
      ))
    :"jpamb.cases.BasicLeaks.explicitDirectSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 122837625
          :relative 1.6174379735570703
        )
        :calibrates (2898833 3029375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127085125
          :relative 1.628914024327842
        )
        :calibrates (3003250 2970000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127414042
          :relative 1.6248210259286657
        )
        :calibrates (3039792 3005625)
      ))
    :"jpamb.cases.BasicLeaks.explicitMixed:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124592000
          :relative 1.62499087590449
        )
        :calibrates (2889333 3019875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 147211125
          :relative 1.7009895695323083
        )
        :calibrates (2862584 2998542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123731417
          :relative 1.612814789497471
        )
        :calibrates (3056333 2978916)
      ))
    :"jpamb.cases.BasicLeaks.explicitMixedSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126733209
          :relative 1.6333138983139663
        )
        :calibrates (2867416 3029250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129022625
          :relative 1.6365710248040712
        )
        :calibrates (2909167 3049167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126715875
          :relative 1.6240241486818678
        )
        :calibrates (3025791 2997542)
      ))
    :"jpamb.cases.BasicLeaks.explicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 119003625
          :relative 1.6093693666128082
        )
        :calibrates (2873083 2977792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 120930791
          :relative 1.616735863252942
        )
        :calibrates (2877084 2968542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121030541
          :relative 1.6174841625915866
        )
        :calibrates (2880334 2960042)
      ))
    :"jpamb.cases.BasicLeaks.explicitReturnSafe:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129733750
          :relative 1.6304830003254451
        )
        :calibrates (3070459 3005292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121863917
          :relative 1.6138045917395525
        )
        :calibrates (2869834 3060792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 120325250
          :relative 1.6044859129058535
        )
        :calibrates (2883375 3099375)
      ))
    :"jpamb.cases.BasicLeaks.implicitAfterBranchSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129656084
          :relative 1.5851791087509821
        )
        :calibrates (3022583 3717167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128250375
          :relative 1.6210087629196333
        )
        :calibrates (3030708 3108041)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128076750
          :relative 1.6265745373697065
        )
        :calibrates (2901333 3151041)
      ))
    :"jpamb.cases.BasicLeaks.implicitIf:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128889500
          :relative 1.626719392021738
        )
        :calibrates (3021667 3067083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130631250
          :relative 1.6425997482757455
        )
        :calibrates (2961416 2988041)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 134924834
          :relative 1.6483538148575856
        )
        :calibrates (2992458 3071666)
      ))
    :"jpamb.cases.BasicLeaks.implicitIfElse:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125401167
          :relative 1.6191583301373136
        )
        :calibrates (2990000 3038000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129664125
          :relative 1.6363565265616797
        )
        :calibrates (2891833 3099084)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129451584
          :relative 1.640027747073042
        )
        :calibrates (2878500 3052250)
      ))
    :"jpamb.cases.BasicLeaks.implicitIfSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 144455375
          :relative 1.6912818030008048
        )
        :calibrates (2862958 3018458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131814083
          :relative 1.6373025720211782
        )
        :calibrates (2997875 3079125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 175054375
          :relative 1.7774773004676823
        )
        :calibrates (2866917 2977291)
      ))
    :"jpamb.cases.BasicLeaks.implicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 143881917
          :relative 1.681899498634998
        )
        :calibrates (2906958 3079042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 149581000
          :relative 1.6917379955514875
        )
        :calibrates (2955334 3128375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123675916
          :relative 1.6233564762085189
        )
        :calibrates (2863417 3024459)
      ))
    :"jpamb.cases.BasicLeaks.implicitSinkInBranch:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125240458
          :relative 1.6147609324231242
        )
        :calibrates (2924042 3157500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123131083
          :relative 1.6222573751893576
        )
        :calibrates (2878792 2998000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121388333
          :relative 1.6043527485488418
        )
        :calibrates (2925375 3112084)
      ))
    :"jpamb.cases.BasicLeaks.implicitWhile:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 659586333
          :relative 2.338881343611749
        )
        :calibrates (2967875 3077459)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 734461667
          :relative 2.387598114942482
        )
        :calibrates (3001125 3016166)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 671208542
          :relative 2.3481436903594566
        )
        :calibrates (2983542 3038500)
      ))
    :"jpamb.cases.BasicLeaks.leakAfterBackEdge:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 133168333
          :relative 1.6483969918057653
        )
        :calibrates (2904875 3079709)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 148855167
          :relative 1.694011116037135
        )
        :calibrates (2908166 3114417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132433958
          :relative 1.6435531405026436
        )
        :calibrates (2891917 3126416)
      ))
    :"jpamb.cases.BasicLeaks.skippedLoop:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124269583
          :relative 1.623259725927432
        )
        :calibrates (2940416 2977041)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123611709
          :relative 1.6127963504665184
        )
        :calibrates (3037791 2991875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123053833
          :relative 1.617603814277972
        )
        :calibrates (2972458 2963917)
      ))
    :"jpamb.cases.BasicLeaks.staticFlagsButDynamicDoesnt:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 134459958
          :relative 1.650697336456997
        )
        :calibrates (2880833 3129875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130524708
          :relative 1.6464170174810673
        )
        :calibrates (2874042 3018541)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132821625
          :relative 1.648257750733923
        )
        :calibrates (2949500 3021417)
      ))
    :"jpamb.cases.Clearance.flowDownOneLevel:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125291625
          :relative 1.613898174068157
        )
        :calibrates (2931583 3164542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 120745167
          :relative 1.6158026126117
        )
        :calibrates (2869667 2979542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 121074750
          :relative 1.6159235363252116
        )
        :calibrates (2872042 2991500)
      ))
    :"jpamb.cases.Clearance.flowUpTwoLevels:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127369541
          :relative 1.6194831253503308
        )
        :calibrates (3086584 3031458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123696916
          :relative 1.6115258300142674
        )
        :calibrates (2891125 3160375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 123882625
          :relative 1.617893253308736
        )
        :calibrates (2930459 3041917)
      ))
    :"jpamb.cases.Clearance.joinBecomesSecret:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126227875
          :relative 1.6302366119038159
        )
        :calibrates (2882584 3032333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138753292
          :relative 1.6751009562182277
        )
        :calibrates (2873208 2990500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129599125
          :relative 1.6429641154730639
        )
        :calibrates (2877750 3019750)
      ))
    :"jpamb.cases.Clearance.joinStaysConfidential:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126415291
          :relative 1.6253846565589312
        )
        :calibrates (2883083 3107167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131334625
          :relative 1.6239897434512316
        )
        :calibrates (2970709 3272667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130038000
          :relative 1.6301711032560418
        )
        :calibrates (2951375 3143000)
      ))
    :"jpamb.cases.Clearance.nestedBranches:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127886958
          :relative 1.6323094428310716
        )
        :calibrates (2881959 3082167)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 169661375
          :relative 1.7340328172657329
        )
        :calibrates (3017334 3242750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132750875
          :relative 1.6351158007479814
        )
        :calibrates (3161292 2989791)
      ))
    :"jpamb.cases.Clearance.secretBranchInLoop:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 267913084
          :relative 1.951941623994811
        )
        :calibrates (2881917 3103333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 263237542
          :relative 1.9103785042188703
        )
        :calibrates (3500833 2970583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 260730875
          :relative 1.9460454357941075
        )
        :calibrates (2872333 3032084)
      ))
    :"jpamb.cases.Clearance.sequentialBranches:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 131727958
          :relative 1.6530049260060349
        )
        :calibrates (2874042 2983333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132960416
          :relative 1.6477486560344707
        )
        :calibrates (2953500 3030667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129701708
          :relative 1.6427190170239003
        )
        :calibrates (2892834 3012666)
      ))
    :"jpamb.cases.Clearance.topSecretBroadcast:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131456333
          :relative 1.649886711492304
        )
        :calibrates (2875709 3011708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 120687209
          :relative 1.6152509110373452
        )
        :calibrates (2884875 2968958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128894667
          :relative 1.6351421638758659
        )
        :calibrates (2865916 3106125)
      ))
    :"jpamb.cases.Compartments.explicitDominatesImplicit:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126249834
          :relative 1.6291450428245604
        )
        :calibrates (2886542 3044292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126284584
          :relative 1.6193825021595347
        )
        :calibrates (2987125 3080208)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 138651083
          :relative 1.6644100928276122
        )
        :calibrates (3019917 2985500)
      ))
    :"jpamb.cases.Compartments.implicitOutsideSink:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125241208
          :relative 1.630058949516801
        )
        :calibrates (2876875 2994209)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 136656208
          :relative 1.6104927181813138
        )
        :calibrates (3553375 3148042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 143418125
          :relative 1.6545384366105296
        )
        :calibrates (2881833 3472875)
      ))
    :"jpamb.cases.Compartments.implicitWithinSink:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127426834
          :relative 1.6136249096757513
        )
        :calibrates (2886167 3317750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 156158083
          :relative 1.717763229625441
        )
        :calibrates (2958208 3023583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 171890542
          :relative 1.6886502229375064
        )
        :calibrates (3965500 3075458)
      ))
    :"jpamb.cases.Compartments.incomparableSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 145560708
          :relative 1.6669826533659369
        )
        :calibrates (3214834 3052625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134184542
          :relative 1.6604706134637504
        )
        :calibrates (2860917 3004000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127020208
          :relative 1.6124644766140641
        )
        :calibrates (3027791 3172875)
      ))
    :"jpamb.cases.Compartments.joinIsLeastUpperBound:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 149996292
          :relative 1.6968202158903718
        )
        :calibrates (2916250 3113375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 147480209
          :relative 1.6980506920025285
        )
        :calibrates (2874292 3037417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 141987042
          :relative 1.6571526363403388
        )
        :calibrates (3006750 3246792)
      ))
    :"jpamb.cases.Compartments.joinOfThree:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125474750
          :relative 1.611323688052096
        )
        :calibrates (3050875 3090458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126222750
          :relative 1.6209509744482045
        )
        :calibrates (2992958 3049542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125654417
          :relative 1.6287183139186816
        )
        :calibrates (2863166 3045500)
      ))
    :"jpamb.cases.Compartments.joinOfThreeToTop:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127078125
          :relative 1.6141767651032748
        )
        :calibrates (3027458 3151625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127766166
          :relative 1.6199705769984085
        )
        :calibrates (3152125 2978084)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128203500
          :relative 1.630380706092407
        )
        :calibrates (2910125 3095375)
      ))
    :"jpamb.cases.Compartments.joinOfTwo:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 137195542
          :relative 1.6629871292687235
        )
        :calibrates (2948292 3013583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127271792
          :relative 1.629066998614778
        )
        :calibrates (3002917 2977000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125547667
          :relative 1.6163905969299124
        )
        :calibrates (2970792 3102834)
      ))
    :"jpamb.cases.Compartments.loopGuardAddsCompartment:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 229740209
          :relative 1.8927111994203794
        )
        :calibrates (2877500 3004917)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 246497958
          :relative 1.9088891727994248
        )
        :calibrates (2993500 3087208)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 241328875
          :relative 1.9004385730957316
        )
        :calibrates (3021834 3048334)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget19:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126989291
          :relative 1.6229669985453206
        )
        :calibrates (3011000 3040041)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127610041
          :relative 1.6136047527267428
        )
        :calibrates (2983041 3230084)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126709167
          :relative 1.625560130352063
        )
        :calibrates (2967208 3034542)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget23:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128502958
          :relative 1.6214448391232588
        )
        :calibrates (3143708 3000958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 141148125
          :relative 1.6516806065711687
        )
        :calibrates (3243000 3052417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126367166
          :relative 1.6241481922079701
        )
        :calibrates (3029084 2975958)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTarget31:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124992583
          :relative 1.6031909140925509
        )
        :calibrates (3248042 2985334)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124810500
          :relative 1.6124856520992696
        )
        :calibrates (3055416 3037083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124817667
          :relative 1.6218928149188478
        )
        :calibrates (2977125 2985167)
      ))
    :"jpamb.cases.FuzzingChallenges.neutralTargetSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125061958
          :relative 1.621811204340547
        )
        :calibrates (2987875 2987209)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128031916
          :relative 1.6234695227395026
        )
        :calibrates (2969292 3124375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127227417
          :relative 1.6353142101248546
        )
        :calibrates (2876708 3015750)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair17:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127259917
          :relative 1.6346304555257978
        )
        :calibrates (2875958 3027292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132209959
          :relative 1.6386674664847327
        )
        :calibrates (3017167 3058958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127647666
          :relative 1.6360314539457108
        )
        :calibrates (2871708 3030458)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair29:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132235750
          :relative 1.6285652435318858
        )
        :calibrates (3127583 3092750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 146411042
          :relative 1.6929544185875205
        )
        :calibrates (2886459 3051667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129164875
          :relative 1.646800812523552
        )
        :calibrates (2860750 2965292)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePair53:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126593208
          :relative 1.6215594222718326
        )
        :calibrates (2973500 3078250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 141648000
          :relative 1.6769425223170111
        )
        :calibrates (2939500 3021209)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 139727667
          :relative 1.6684507068588839
        )
        :calibrates (2976959 3019042)
      ))
    :"jpamb.cases.FuzzingChallenges.opaquePairSafe:(III)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126241791
          :relative 1.6216847727035828
        )
        :calibrates (2958167 3075042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131451208
          :relative 1.648136703666726
        )
        :calibrates (2890708 3020250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 135890292
          :relative 1.650109464095494
        )
        :calibrates (2909084 3173792)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget1031:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133129500
          :relative 1.6475512595937327
        )
        :calibrates (2978042 3016459)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 156061917
          :relative 1.7253899594566995
        )
        :calibrates (2910666 2963375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127875541
          :relative 1.6288979186116779
        )
        :calibrates (2961666 3048958)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget257:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 160290875
          :relative 1.733436805769833
        )
        :calibrates (2944375 2978083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129888166
          :relative 1.6476881757712876
        )
        :calibrates (2867125 2979583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128156917
          :relative 1.641999865737078
        )
        :calibrates (2878709 2966125)
      ))
    :"jpamb.cases.FuzzingChallenges.productTarget509:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127806500
          :relative 1.6366880137490665
        )
        :calibrates (2877833 3022750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129178166
          :relative 1.6380885828125094
        )
        :calibrates (2918500 3026208)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126456084
          :relative 1.630641928827642
        )
        :calibrates (2864375 3055708)
      ))
    :"jpamb.cases.FuzzingChallenges.productTargetSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132627542
          :relative 1.6474469174625896
        )
        :calibrates (2918667 3054667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128728833
          :relative 1.6418612822964946
        )
        :calibrates (2860083 3012708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127902667
          :relative 1.6393361628896936
        )
        :calibrates (2895042 2974084)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask3:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 145597209
          :relative 1.4337857447326126
        )
        :calibrates (7683458 3041542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126577000
          :relative 1.6327996977536847
        )
        :calibrates (2881791 3014584)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126522042
          :relative 1.6355487712312728
        )
        :calibrates (2877667 2978958)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask4:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128004500
          :relative 1.6398176047572774
        )
        :calibrates (2862083 3005208)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131644375
          :relative 1.6421965901941062
        )
        :calibrates (2879875 3121292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128061541
          :relative 1.6237273937351657
        )
        :calibrates (2880667 3210792)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMask5:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126077083
          :relative 1.6248712157181546
        )
        :calibrates (2896708 3084583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132282917
          :relative 1.644808035814979
        )
        :calibrates (3011416 2982708)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130635416
          :relative 1.6274191366050994
        )
        :calibrates (3162250 2999042)
      ))
    :"jpamb.cases.FuzzingChallenges.stagedMaskSafe:(IIII)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128918291
          :relative 1.6409651312064149
        )
        :calibrates (2881250 3012333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124162833
          :relative 1.6120357313356237
        )
        :calibrates (2864208 3202958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124825667
          :relative 1.6303759895616434
        )
        :calibrates (2869417 2977917)
      ))
    :"jpamb.cases.Hospital.adminCombinesDepartments:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 162676375
          :relative 1.7361408091733257
        )
        :calibrates (2937916 3035375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 133474333
          :relative 1.628727520553849
        )
        :calibrates (3315583 2960667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126595458
          :relative 1.6321577658083883
        )
        :calibrates (2860083 3045875)
      ))
    :"jpamb.cases.Hospital.combinedToOneDepartment:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122397250
          :relative 1.6171467948215454
        )
        :calibrates (2891500 3019417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125856709
          :relative 1.633058186241144
        )
        :calibrates (2867875 2991458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 143129500
          :relative 1.6888430062624924
        )
        :calibrates (2873708 2986542)
      ))
    :"jpamb.cases.Hospital.compartmentLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 118607917
          :relative 1.6048072334339918
        )
        :calibrates (2863333 3029667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 119388167
          :relative 1.6058652700283944
        )
        :calibrates (2860458 3056875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 123238458
          :relative 1.6154686525025967
        )
        :calibrates (2876875 3097708)
      ))
    :"jpamb.cases.Hospital.deadBranchLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125132917
          :relative 1.6251332915677692
        )
        :calibrates (2887417 3045500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127785667
          :relative 1.6203913696777195
        )
        :calibrates (3036916 3088291)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127823750
          :relative 1.6314400194336047
        )
        :calibrates (2977333 2995791)
      ))
    :"jpamb.cases.Hospital.implicitCompartmentLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129279041
          :relative 1.631967782609945
        )
        :calibrates (3034500 2999292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 134683041
          :relative 1.6452652519755953
        )
        :calibrates (3015084 3081375)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126985917
          :relative 1.633991845921698
        )
        :calibrates (2862375 3036833)
      ))
    :"jpamb.cases.Hospital.oncologyOnly:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 132271958
          :relative 1.6486199507443915
        )
        :calibrates (2876375 3064875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 138324417
          :relative 1.6587430865102306
        )
        :calibrates (2968917 3101042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 152637375
          :relative 1.710383817415971
        )
        :calibrates (2905000 3042125)
      ))
    :"jpamb.cases.Hospital.process:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126607833
          :relative 1.6183951760825879
        )
        :calibrates (2906250 3190458)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122632042
          :relative 1.619002827837321
        )
        :calibrates (2858875 3038125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124105333
          :relative 1.6130112304013295
        )
        :calibrates (3006375 3044375)
      ))
    :"jpamb.cases.Hospital.psychSessionCount:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 676242875
          :relative 2.3320363182539414
        )
        :calibrates (3206167 3090292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 675044584
          :relative 2.348541328845798
        )
        :calibrates (2910416 3140500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 680703792
          :relative 2.361535016658342
        )
        :calibrates (2886667 3035125)
      ))
    :"jpamb.cases.Hospital.publicRiskScore:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 125934750
          :relative 1.6294105229749263
        )
        :calibrates (2923000 2989417)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 140462166
          :relative 1.638774459769723
        )
        :calibrates (3378375 3075416)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127343375
          :relative 1.625545018652474
        )
        :calibrates (3004833 3027167)
      ))
    :"jpamb.cases.Hospital.sameValueBothBranches:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126713875
          :relative 1.6216055569023236
        )
        :calibrates (3003917 3052958)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128671875
          :relative 1.6400206805640254
        )
        :calibrates (2907333 2987791)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131784666
          :relative 1.6350491065881536
        )
        :calibrates (3041209 3066042)
      ))
    :"jpamb.cases.InfoFlow.deadBranchLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128940834
          :relative 1.6152452333724723
        )
        :calibrates (3008000 3246250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 141619875
          :relative 1.669884654779931
        )
        :calibrates (2931667 3125500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 122984917
          :relative 1.6180621620379463
        )
        :calibrates (2961125 2965667)
      ))
    :"jpamb.cases.InfoFlow.explicitLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124513208
          :relative 1.6205379291811433
        )
        :calibrates (2945083 3021250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 139081250
          :relative 1.6563129489931465
        )
        :calibrates (3006750 3130667)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 121952041
          :relative 1.6075413532780378
        )
        :calibrates (2982834 3038292)
      ))
    :"jpamb.cases.InfoFlow.explicitSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129014458
          :relative 1.626261444647565
        )
        :calibrates (2987458 3113625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 141226042
          :relative 1.6701445422535144
        )
        :calibrates (3013584 3023125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128388667
          :relative 1.6404163656647903
        )
        :calibrates (2872958 3003834)
      ))
    :"jpamb.cases.InfoFlow.implicitLeak:(Z)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130205208
          :relative 1.6312580461958548
        )
        :calibrates (3056125 3030833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 155661167
          :relative 1.706062848904123
        )
        :calibrates (2919500 3206083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126950709
          :relative 1.635684977213101
        )
        :calibrates (2867417 3007208)
      ))
    :"jpamb.cases.InfoFlow.implicitReturn:(I)I" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 128926875
          :relative 1.638938711162488
        )
        :calibrates (2944791 2976750)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127456583
          :relative 1.601401443430735
        )
        :calibrates (3004625 3377875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok covered-not-found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121699875
          :relative 1.6139464115814546
        )
        :calibrates (2925875 2994834)
      ))
    :"jpamb.cases.InfoFlow.launderedThroughArithmetic:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133228500
          :relative 1.6491076217944938
        )
        :calibrates (2902708 3074791)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 131459750
          :relative 1.636532663849347
        )
        :calibrates (3038709 3032709)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129616334
          :relative 1.6447650293916098
        )
        :calibrates (2880250 2993625)
      ))
    :"jpamb.cases.InfoFlow.loopCountLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 695880292
          :relative 2.362425791273944
        )
        :calibrates (3057000 2984416)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 668965458
          :relative 2.349732505247152
        )
        :calibrates (2926708 3053292)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 673917292
          :relative 2.357424943764522
        )
        :calibrates (2947000 2971500)
      ))
    :"jpamb.cases.InfoFlow.loopThenConstant:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 728486458
          :relative 2.3514829042344143
        )
        :calibrates (3449000 3036875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 652439083
          :relative 2.338266995139441
        )
        :calibrates (3011833 2976459)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 656031750
          :relative 2.3359572035580043
        )
        :calibrates (2894667 3158709)
      ))
    :"jpamb.cases.InfoFlow.overwrittenBeforeSink:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 124088125
          :relative 1.6203740712382655
        )
        :calibrates (2965375 2982833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 135940791
          :relative 1.6567868202320446
        )
        :calibrates (2877417 3114875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 130946166
          :relative 1.6446959860278918
        )
        :calibrates (2972875 2962208)
      ))
    :"jpamb.cases.InfoFlow.pcRestoredAfterBranch:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 127506000
          :relative 1.6325518178741565
        )
        :calibrates (2953250 2989792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129114000
          :relative 1.6216360324420849
        )
        :calibrates (3057542 3113625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" covered-not-found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 129489833
          :relative 1.6434146417005053
        )
        :calibrates (2872500 3013917)
      ))
    :"jpamb.cases.InfoFlow.sinkUnderSecretBranch:(Z)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 126342542
          :relative 1.6241268430610403
        )
        :calibrates (2963625 3040542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 121602917
          :relative 1.6148062344809666
        )
        :calibrates (2881708 3022583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" covered-not-found
            :"null pointer" covered-not-found
            :ok found
            :"out of bounds" covered-not-found
          )
        )
        :duration (duration
          :absolute 135321041
          :relative 1.6641519681413952
        )
        :calibrates (2866542 2998125)
      ))
    :"jpamb.cases.PrecisionBenchmarks.bitwiseMaskBoundSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138923292
          :relative 1.6571867158453841
        )
        :calibrates (3055583 3062542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128595667
          :relative 1.6336398354806303
        )
        :calibrates (2921959 3056875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 137199625
          :relative 1.641571593282409
        )
        :calibrates (3219250 3044167)
      ))
    :"jpamb.cases.PrecisionBenchmarks.bitwiseOrNonZeroSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138877166
          :relative 1.65608822969321
        )
        :calibrates (2993583 3138000)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129110334
          :relative 1.6249558891723495
        )
        :calibrates (3036458 3087541)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 130040833
          :relative 1.637788711189449
        )
        :calibrates (2872250 3116291)
      ))
    :"jpamb.cases.PrecisionBenchmarks.contradictoryRangeSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134579959
          :relative 1.6452979739346087
        )
        :calibrates (2932792 3158542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 124695291
          :relative 1.6270844356279628
        )
        :calibrates (2884541 3001125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 164605416
          :relative 1.7376462553738627
        )
        :calibrates (2960083 3063125)
      ))
    :"jpamb.cases.PrecisionBenchmarks.correlatedBranchSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 136635625
          :relative 1.646881129876183
        )
        :calibrates (3162208 2999666)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128679583
          :relative 1.6312378047383596
        )
        :calibrates (2966833 3049084)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 138352375
          :relative 1.6702821890526387
        )
        :calibrates (2884166 3027834)
      ))
    :"jpamb.cases.PrecisionBenchmarks.helperPassthroughLeak:(I)V" ((analysis-result
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
          :absolute 127176375
          :relative 1.6292287993969656
        )
        :calibrates (2886833 3086375)
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
          :absolute 122585375
          :relative 1.60773718575236
        )
        :calibrates (3009542 3040125)
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
          :absolute 125734917
          :relative 1.6291985558787478
        )
        :calibrates (2863792 3042125)
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
          :absolute 126943875
          :relative 1.633274702434282
        )
        :calibrates (2906209 3000792)
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
          :absolute 127928708
          :relative 1.6420532478392367
        )
        :calibrates (2872209 2961500)
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
          :absolute 128308584
          :relative 1.6415920209412218
        )
        :calibrates (2857041 3000208)
      ))
    :"jpamb.cases.PrecisionBenchmarks.intervalHullHoleSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133416750
          :relative 1.6429026534509266
        )
        :calibrates (3037917 3034166)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 146359541
          :relative 1.644029581584062
        )
        :calibrates (3122833 3521042)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126160875
          :relative 1.6303947648328942
        )
        :calibrates (2893083 3016542)
      ))
    :"jpamb.cases.PrecisionBenchmarks.largeLoopWideningSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* timeout
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 2124457083
          :relative 2.8377113326770025
        )
        :calibrates (3087208 3086792)
      ) (analysis-result
        :response (response
          :predictions (
            :* timeout
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 2124188916
          :relative 2.7048280196431747
        )
        :calibrates (5307083 3075833)
      ) (analysis-result
        :response (response
          :predictions (
            :* timeout
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 2139184458
          :relative 2.860542757686806
        )
        :calibrates (2896792 3001625)
      ))
    :"jpamb.cases.PrecisionBenchmarks.loopExitBoundSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 202058833
          :relative 1.819605643370111
        )
        :calibrates (2948875 3173250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 194481584
          :relative 1.8087966235773982
        )
        :calibrates (2941250 3099792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 199497458
          :relative 1.8292421191226929
        )
        :calibrates (2882500 3029375)
      ))
    :"jpamb.cases.PrecisionBenchmarks.overflowDeadBranchSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129075166
          :relative 1.630817773903612
        )
        :calibrates (2947750 3092500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 126793041
          :relative 1.6190003149479668
        )
        :calibrates (3024208 3072917)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127504708
          :relative 1.6369451140176685
        )
        :calibrates (2908083 2975083)
      ))
    :"jpamb.cases.PrecisionBenchmarks.overflowPrunedBySyntacticLeak:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 146246000
          :relative 1.694275486630693
        )
        :calibrates (2935625 2977792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 150431333
          :relative 1.6973103657437192
        )
        :calibrates (2985667 3054625)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133513667
          :relative 1.6029456807078926
        )
        :calibrates (2961083 3701000)
      ))
    :"jpamb.cases.PrecisionBenchmarks.paritySafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129806125
          :relative 1.642388861616118
        )
        :calibrates (2903416 3011333)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132791291
          :relative 1.650861195358435
        )
        :calibrates (2901000 3032875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134150000
          :relative 1.5466537897441544
        )
        :calibrates (4636459 2983750)
      ))
    :"jpamb.cases.PrecisionBenchmarks.recursiveCountdownLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128986042
          :relative 1.632731409595865
        )
        :calibrates (2997708 3011833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 133812250
          :relative 1.6446145852677054
        )
        :calibrates (2966541 3099583)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127448583
          :relative 1.634939810537011
        )
        :calibrates (2874084 3033708)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalAlwaysLeak:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 128053208
          :relative 1.6340616924491886
        )
        :calibrates (2881958 3065875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127070958
          :relative 1.635671203385586
        )
        :calibrates (2884834 2995542)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok not-found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 143574167
          :relative 1.6861913487908324
        )
        :calibrates (2890750 3023708)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalOrderSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127319500
          :relative 1.6375211939306533
        )
        :calibrates (2886750 2980083)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 127897542
          :relative 1.632870717686468
        )
        :calibrates (2874083 3082833)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 132238375
          :relative 1.596469395148334
        )
        :calibrates (3110750 3586833)
      ))
    :"jpamb.cases.PrecisionBenchmarks.relationalSelfCancelSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 125119416
          :relative 1.6293468333534247
        )
        :calibrates (2883125 2991875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 129538459
          :relative 1.6411315184037216
        )
        :calibrates (2885416 3034250)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 143207250
          :relative 1.6145808006587283
        )
        :calibrates (2986041 3970834)
      ))
    :"jpamb.cases.PrecisionBenchmarks.signHoleRangeSafe:(II)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 134257625
          :relative 1.6221448040948123
        )
        :calibrates (2898625 3510875)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 137436458
          :relative 1.6439676832448482
        )
        :calibrates (3053916 3185792)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 135662750
          :relative 1.6422504174615178
        )
        :calibrates (3148916 3034667)
      ))
    :"jpamb.cases.PrecisionBenchmarks.wideningOvershootSafe:(I)V" ((analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 179905167
          :relative 1.783886489803237
        )
        :calibrates (2935666 2982500)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 177653208
          :relative 1.7675008685975315
        )
        :calibrates (2967666 3101125)
      ) (analysis-result
        :response (response
          :predictions (
            :* not-found
            :"assertion error" not-found
            :"divide by zero" not-found
            :"null pointer" not-found
            :ok found
            :"out of bounds" not-found
          )
        )
        :duration (duration
          :absolute 189810292
          :relative 1.803196648600402
        )
        :calibrates (2899542 3072916)
      ))
  )
)