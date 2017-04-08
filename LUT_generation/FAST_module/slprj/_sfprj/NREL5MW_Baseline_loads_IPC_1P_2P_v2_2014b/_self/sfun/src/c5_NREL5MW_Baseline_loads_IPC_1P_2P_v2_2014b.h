#ifndef __c5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_h__
#define __c5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_h__

/* Include files */
#include "sf_runtime/sfc_sf.h"
#include "sf_runtime/sfc_mex.h"
#include "rtwtypes.h"
#include "multiword_types.h"

/* Type Definitions */
#ifndef typedef_SFc5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014bInstanceStruct
#define typedef_SFc5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014bInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c5_sfEvent;
  boolean_T c5_isStable;
  boolean_T c5_doneDoubleBufferReInit;
  uint8_T c5_is_active_c5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b;
  real_T c5_DT;
  real_T c5_y;
  boolean_T c5_y_not_empty;
  real_T *c5_u;
  real_T *c5_MinSaturation;
  real_T *c5_y_out;
  real_T *c5_MaxSaturation;
} SFc5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014bInstanceStruct;

#endif                                 /*typedef_SFc5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014bInstanceStruct*/

/* Named Constants */

/* Variable Declarations */
extern struct SfDebugInstanceStruct *sfGlobalDebugInstanceStruct;

/* Variable Definitions */

/* Function Declarations */
extern const mxArray
  *sf_c5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_get_eml_resolved_functions_info
  (void);

/* Function Definitions */
extern void sf_c5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_get_check_sum
  (mxArray *plhs[]);
extern void c5_NREL5MW_Baseline_loads_IPC_1P_2P_v2_2014b_method_dispatcher
  (SimStruct *S, int_T method, void *data);

#endif
