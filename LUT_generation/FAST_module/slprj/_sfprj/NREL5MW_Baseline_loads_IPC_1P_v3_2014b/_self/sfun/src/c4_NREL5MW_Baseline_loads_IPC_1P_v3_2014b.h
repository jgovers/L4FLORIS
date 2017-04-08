#ifndef __c4_NREL5MW_Baseline_loads_IPC_1P_v3_2014b_h__
#define __c4_NREL5MW_Baseline_loads_IPC_1P_v3_2014b_h__

/* Include files */
#include "sf_runtime/sfc_sf.h"
#include "sf_runtime/sfc_mex.h"
#include "rtwtypes.h"
#include "multiword_types.h"

/* Type Definitions */
#ifndef typedef_SFc4_NREL5MW_Baseline_loads_IPC_1P_v3_2014bInstanceStruct
#define typedef_SFc4_NREL5MW_Baseline_loads_IPC_1P_v3_2014bInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c4_sfEvent;
  boolean_T c4_isStable;
  boolean_T c4_doneDoubleBufferReInit;
  uint8_T c4_is_active_c4_NREL5MW_Baseline_loads_IPC_1P_v3_2014b;
  real_T c4_omega_A;
  real_T c4_omega_B;
  real_T c4_omega_C;
  real_T c4_Demanded_torque;
  real_T c4_Pitch_fine;
  real_T *c4_PrevTorque;
  real_T *c4_MeasTorque;
  real_T *c4_MeasPitch;
  real_T *c4_ModeGain;
  real_T *c4_GenSpeed;
  real_T *c4_GenTorque;
  real_T *c4_RatedSpeed;
  real_T *c4_KillIntegrator;
  real_T *c4_Mode;
} SFc4_NREL5MW_Baseline_loads_IPC_1P_v3_2014bInstanceStruct;

#endif                                 /*typedef_SFc4_NREL5MW_Baseline_loads_IPC_1P_v3_2014bInstanceStruct*/

/* Named Constants */

/* Variable Declarations */
extern struct SfDebugInstanceStruct *sfGlobalDebugInstanceStruct;

/* Variable Definitions */

/* Function Declarations */
extern const mxArray
  *sf_c4_NREL5MW_Baseline_loads_IPC_1P_v3_2014b_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c4_NREL5MW_Baseline_loads_IPC_1P_v3_2014b_get_check_sum(mxArray
  *plhs[]);
extern void c4_NREL5MW_Baseline_loads_IPC_1P_v3_2014b_method_dispatcher
  (SimStruct *S, int_T method, void *data);

#endif
