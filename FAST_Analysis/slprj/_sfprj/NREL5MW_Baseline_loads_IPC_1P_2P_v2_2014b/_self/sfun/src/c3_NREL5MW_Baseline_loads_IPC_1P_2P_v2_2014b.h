#ifndef __c3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_h__
#define __c3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_h__

/* Include files */
#include "sf_runtime/sfc_sf.h"
#include "sf_runtime/sfc_mex.h"
#include "rtwtypes.h"
#include "multiword_types.h"

/* Type Definitions */
#ifndef typedef_SFc3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014bInstanceStruct
#define typedef_SFc3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014bInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c3_sfEvent;
  boolean_T c3_isStable;
  boolean_T c3_doneDoubleBufferReInit;
  uint8_T c3_is_active_c3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b;
  real_T c3_omega_C;
  real_T c3_Demanded_torque;
  real_T *c3_ErrorSpeed;
  real_T *c3_SpeedError;
  real_T *c3_GenSpeed;
  real_T *c3_MeasTorque;
  real_T *c3_MeasPitch;
  real_T *c3_KillIntegrator;
} SFc3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014bInstanceStruct;

#endif                                 /*typedef_SFc3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014bInstanceStruct*/

/* Named Constants */

/* Variable Declarations */
extern struct SfDebugInstanceStruct *sfGlobalDebugInstanceStruct;

/* Variable Definitions */

/* Function Declarations */
extern const mxArray
  *sf_c3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_get_check_sum
  (mxArray *plhs[]);
extern void c3_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_method_dispatcher
  (SimStruct *S, int_T method, void *data);

#endif
