/* Include files */

#include <stddef.h>
#include "blas.h"
#include "NREL5MW_Baseline_loads_2014b_sfun.h"
#include "c4_NREL5MW_Baseline_loads_2014b.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "NREL5MW_Baseline_loads_2014b_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)
#define c4_const_omega_A               (0.0)

/* Variable Declarations */

/* Variable Definitions */
static real_T _sfTime_;
static const char * c4_debug_family_names[22] = { "aVarTruthTableCondition_1",
  "aVarTruthTableCondition_2", "aVarTruthTableCondition_3",
  "aVarTruthTableCondition_4", "aVarTruthTableCondition_5",
  "aVarTruthTableCondition_6", "aVarTruthTableCondition_7", "nargin", "nargout",
  "PrevTorque", "MeasTorque", "MeasPitch", "ModeGain", "GenSpeed", "omega_B",
  "omega_C", "Demanded_torque", "Pitch_fine", "GenTorque", "RatedSpeed",
  "KillIntegrator", "Mode" };

/* Function Declarations */
static void initialize_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void initialize_params_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void enable_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void disable_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void c4_update_debugger_state_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void set_sim_state_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_st);
static void finalize_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void sf_gateway_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void mdl_start_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void c4_chartstep_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void initSimStructsc4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c4_machineNumber, uint32_T
  c4_chartNumber, uint32_T c4_instanceNumber);
static const mxArray *c4_sf_marshallOut(void *chartInstanceVoid, void *c4_inData);
static real_T c4_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_b_Mode, const char_T *c4_identifier);
static real_T c4_b_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_u, const emlrtMsgIdentifier *c4_parentId);
static void c4_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData);
static const mxArray *c4_b_sf_marshallOut(void *chartInstanceVoid, void
  *c4_inData);
static boolean_T c4_c_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_u, const emlrtMsgIdentifier *c4_parentId);
static void c4_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData);
static void c4_info_helper(const mxArray **c4_info);
static const mxArray *c4_emlrt_marshallOut(const char * c4_u);
static const mxArray *c4_b_emlrt_marshallOut(const uint32_T c4_u);
static const mxArray *c4_c_sf_marshallOut(void *chartInstanceVoid, void
  *c4_inData);
static int32_T c4_d_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_u, const emlrtMsgIdentifier *c4_parentId);
static void c4_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData);
static uint8_T c4_e_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_b_is_active_c4_NREL5MW_Baseline_loads_2014b, const char_T *c4_identifier);
static uint8_T c4_f_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_u, const emlrtMsgIdentifier *c4_parentId);
static void init_dsm_address_info
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);
static void init_simulink_io_address
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  chartInstance->c4_sfEvent = CALL_EVENT;
  _sfTime_ = sf_get_time(chartInstance->S);
  chartInstance->c4_is_active_c4_NREL5MW_Baseline_loads_2014b = 0U;
  chartInstance->c4_omega_A = 0.0;
}

static void initialize_params_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  real_T c4_d0;
  real_T c4_d1;
  real_T c4_d2;
  real_T c4_d3;
  sf_mex_import_named("omega_B", sf_mex_get_sfun_param(chartInstance->S, 2, 0),
                      &c4_d0, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c4_omega_B = c4_d0;
  sf_mex_import_named("omega_C", sf_mex_get_sfun_param(chartInstance->S, 3, 0),
                      &c4_d1, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c4_omega_C = c4_d1;
  sf_mex_import_named("Demanded_torque", sf_mex_get_sfun_param(chartInstance->S,
    0, 0), &c4_d2, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c4_Demanded_torque = c4_d2;
  sf_mex_import_named("Pitch_fine", sf_mex_get_sfun_param(chartInstance->S, 1, 0),
                      &c4_d3, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c4_Pitch_fine = c4_d3;
}

static void enable_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  _sfTime_ = sf_get_time(chartInstance->S);
}

static void disable_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  _sfTime_ = sf_get_time(chartInstance->S);
}

static void c4_update_debugger_state_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  (void)chartInstance;
}

static const mxArray *get_sim_state_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  const mxArray *c4_st;
  const mxArray *c4_y = NULL;
  real_T c4_hoistedGlobal;
  real_T c4_u;
  const mxArray *c4_b_y = NULL;
  real_T c4_b_hoistedGlobal;
  real_T c4_b_u;
  const mxArray *c4_c_y = NULL;
  real_T c4_c_hoistedGlobal;
  real_T c4_c_u;
  const mxArray *c4_d_y = NULL;
  real_T c4_d_hoistedGlobal;
  real_T c4_d_u;
  const mxArray *c4_e_y = NULL;
  uint8_T c4_e_hoistedGlobal;
  uint8_T c4_e_u;
  const mxArray *c4_f_y = NULL;
  c4_st = NULL;
  c4_st = NULL;
  c4_y = NULL;
  sf_mex_assign(&c4_y, sf_mex_createcellmatrix(5, 1), false);
  c4_hoistedGlobal = *chartInstance->c4_GenTorque;
  c4_u = c4_hoistedGlobal;
  c4_b_y = NULL;
  sf_mex_assign(&c4_b_y, sf_mex_create("y", &c4_u, 0, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c4_y, 0, c4_b_y);
  c4_b_hoistedGlobal = *chartInstance->c4_KillIntegrator;
  c4_b_u = c4_b_hoistedGlobal;
  c4_c_y = NULL;
  sf_mex_assign(&c4_c_y, sf_mex_create("y", &c4_b_u, 0, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c4_y, 1, c4_c_y);
  c4_c_hoistedGlobal = *chartInstance->c4_Mode;
  c4_c_u = c4_c_hoistedGlobal;
  c4_d_y = NULL;
  sf_mex_assign(&c4_d_y, sf_mex_create("y", &c4_c_u, 0, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c4_y, 2, c4_d_y);
  c4_d_hoistedGlobal = *chartInstance->c4_RatedSpeed;
  c4_d_u = c4_d_hoistedGlobal;
  c4_e_y = NULL;
  sf_mex_assign(&c4_e_y, sf_mex_create("y", &c4_d_u, 0, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c4_y, 3, c4_e_y);
  c4_e_hoistedGlobal =
    chartInstance->c4_is_active_c4_NREL5MW_Baseline_loads_2014b;
  c4_e_u = c4_e_hoistedGlobal;
  c4_f_y = NULL;
  sf_mex_assign(&c4_f_y, sf_mex_create("y", &c4_e_u, 3, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c4_y, 4, c4_f_y);
  sf_mex_assign(&c4_st, c4_y, false);
  return c4_st;
}

static void set_sim_state_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_st)
{
  const mxArray *c4_u;
  chartInstance->c4_doneDoubleBufferReInit = true;
  c4_u = sf_mex_dup(c4_st);
  *chartInstance->c4_GenTorque = c4_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c4_u, 0)), "GenTorque");
  *chartInstance->c4_KillIntegrator = c4_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c4_u, 1)), "KillIntegrator");
  *chartInstance->c4_Mode = c4_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c4_u, 2)), "Mode");
  *chartInstance->c4_RatedSpeed = c4_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c4_u, 3)), "RatedSpeed");
  chartInstance->c4_is_active_c4_NREL5MW_Baseline_loads_2014b =
    c4_e_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c4_u, 4)),
    "is_active_c4_NREL5MW_Baseline_loads_2014b");
  sf_mex_destroy(&c4_u);
  c4_update_debugger_state_c4_NREL5MW_Baseline_loads_2014b(chartInstance);
  sf_mex_destroy(&c4_st);
}

static void finalize_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  (void)chartInstance;
}

static void sf_gateway_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  _SFD_SYMBOL_SCOPE_PUSH(0U, 0U);
  _sfTime_ = sf_get_time(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 3U, chartInstance->c4_sfEvent);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_PrevTorque, 0U);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_MeasTorque, 1U);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_MeasPitch, 2U);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_ModeGain, 3U);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_GenSpeed, 4U);
  chartInstance->c4_sfEvent = CALL_EVENT;
  c4_chartstep_c4_NREL5MW_Baseline_loads_2014b(chartInstance);
  _SFD_SYMBOL_SCOPE_POP();
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_NREL5MW_Baseline_loads_2014bMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_GenTorque, 5U);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_RatedSpeed, 6U);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_KillIntegrator, 7U);
  _SFD_DATA_RANGE_CHECK(chartInstance->c4_omega_A, 8U);
  _SFD_DATA_RANGE_CHECK(chartInstance->c4_omega_B, 9U);
  _SFD_DATA_RANGE_CHECK(chartInstance->c4_omega_C, 10U);
  _SFD_DATA_RANGE_CHECK(chartInstance->c4_Demanded_torque, 11U);
  _SFD_DATA_RANGE_CHECK(*chartInstance->c4_Mode, 12U);
  _SFD_DATA_RANGE_CHECK(chartInstance->c4_Pitch_fine, 13U);
}

static void mdl_start_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  (void)chartInstance;
}

static void c4_chartstep_c4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  real_T c4_hoistedGlobal;
  real_T c4_b_hoistedGlobal;
  real_T c4_c_hoistedGlobal;
  real_T c4_d_hoistedGlobal;
  real_T c4_e_hoistedGlobal;
  real_T c4_f_hoistedGlobal;
  real_T c4_g_hoistedGlobal;
  real_T c4_h_hoistedGlobal;
  real_T c4_i_hoistedGlobal;
  real_T c4_b_PrevTorque;
  real_T c4_b_MeasTorque;
  real_T c4_b_MeasPitch;
  real_T c4_b_ModeGain;
  real_T c4_b_GenSpeed;
  real_T c4_b_omega_B;
  real_T c4_b_omega_C;
  real_T c4_b_Demanded_torque;
  real_T c4_b_Pitch_fine;
  uint32_T c4_debug_family_var_map[22];
  boolean_T c4_aVarTruthTableCondition_1;
  boolean_T c4_aVarTruthTableCondition_2;
  boolean_T c4_aVarTruthTableCondition_3;
  boolean_T c4_aVarTruthTableCondition_4;
  boolean_T c4_aVarTruthTableCondition_5;
  boolean_T c4_aVarTruthTableCondition_6;
  boolean_T c4_aVarTruthTableCondition_7;
  real_T c4_nargin = 9.0;
  real_T c4_nargout = 4.0;
  real_T c4_b_GenTorque;
  real_T c4_b_RatedSpeed;
  real_T c4_b_KillIntegrator;
  real_T c4_b_Mode;
  boolean_T guard1 = false;
  boolean_T guard2 = false;
  boolean_T guard3 = false;
  boolean_T guard4 = false;
  boolean_T guard5 = false;
  boolean_T guard6 = false;
  boolean_T guard7 = false;
  boolean_T guard8 = false;
  boolean_T guard9 = false;
  boolean_T guard10 = false;
  boolean_T guard11 = false;
  boolean_T guard12 = false;
  boolean_T guard13 = false;
  boolean_T guard14 = false;
  boolean_T guard15 = false;
  boolean_T guard16 = false;
  boolean_T guard17 = false;
  boolean_T guard18 = false;
  boolean_T guard19 = false;
  boolean_T guard20 = false;
  boolean_T guard21 = false;
  boolean_T guard22 = false;
  boolean_T guard23 = false;
  boolean_T guard24 = false;
  boolean_T guard25 = false;
  boolean_T guard26 = false;
  boolean_T guard27 = false;
  boolean_T guard28 = false;
  boolean_T guard29 = false;
  boolean_T guard30 = false;
  boolean_T guard31 = false;
  boolean_T guard32 = false;
  boolean_T guard33 = false;
  boolean_T guard34 = false;
  boolean_T guard35 = false;
  boolean_T guard36 = false;
  boolean_T guard37 = false;
  boolean_T guard38 = false;
  boolean_T guard39 = false;
  boolean_T guard40 = false;
  boolean_T guard41 = false;
  boolean_T guard42 = false;
  boolean_T guard43 = false;
  boolean_T guard44 = false;
  boolean_T guard45 = false;
  boolean_T guard46 = false;
  boolean_T guard47 = false;
  boolean_T guard48 = false;
  boolean_T guard49 = false;
  boolean_T guard50 = false;
  boolean_T guard51 = false;
  boolean_T guard52 = false;
  boolean_T guard53 = false;
  boolean_T guard54 = false;
  boolean_T guard55 = false;
  boolean_T guard56 = false;
  boolean_T guard57 = false;
  boolean_T guard58 = false;
  boolean_T guard59 = false;
  boolean_T guard60 = false;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 3U, chartInstance->c4_sfEvent);
  c4_hoistedGlobal = *chartInstance->c4_PrevTorque;
  c4_b_hoistedGlobal = *chartInstance->c4_MeasTorque;
  c4_c_hoistedGlobal = *chartInstance->c4_MeasPitch;
  c4_d_hoistedGlobal = *chartInstance->c4_ModeGain;
  c4_e_hoistedGlobal = *chartInstance->c4_GenSpeed;
  c4_f_hoistedGlobal = chartInstance->c4_omega_B;
  c4_g_hoistedGlobal = chartInstance->c4_omega_C;
  c4_h_hoistedGlobal = chartInstance->c4_Demanded_torque;
  c4_i_hoistedGlobal = chartInstance->c4_Pitch_fine;
  c4_b_PrevTorque = c4_hoistedGlobal;
  c4_b_MeasTorque = c4_b_hoistedGlobal;
  c4_b_MeasPitch = c4_c_hoistedGlobal;
  c4_b_ModeGain = c4_d_hoistedGlobal;
  c4_b_GenSpeed = c4_e_hoistedGlobal;
  c4_b_omega_B = c4_f_hoistedGlobal;
  c4_b_omega_C = c4_g_hoistedGlobal;
  c4_b_Demanded_torque = c4_h_hoistedGlobal;
  c4_b_Pitch_fine = c4_i_hoistedGlobal;
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 22U, 22U, c4_debug_family_names,
    c4_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_aVarTruthTableCondition_1, 0U,
    c4_b_sf_marshallOut, c4_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_aVarTruthTableCondition_2, 1U,
    c4_b_sf_marshallOut, c4_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_aVarTruthTableCondition_3, 2U,
    c4_b_sf_marshallOut, c4_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_aVarTruthTableCondition_4, 3U,
    c4_b_sf_marshallOut, c4_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_aVarTruthTableCondition_5, 4U,
    c4_b_sf_marshallOut, c4_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_aVarTruthTableCondition_6, 5U,
    c4_b_sf_marshallOut, c4_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_aVarTruthTableCondition_7, 6U,
    c4_b_sf_marshallOut, c4_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_nargin, 7U, c4_sf_marshallOut,
    c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_nargout, 8U, c4_sf_marshallOut,
    c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c4_b_PrevTorque, 9U, c4_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c4_b_MeasTorque, 10U, c4_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c4_b_MeasPitch, 11U, c4_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c4_b_ModeGain, 12U, c4_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c4_b_GenSpeed, 13U, c4_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_b_omega_B, 14U, c4_sf_marshallOut,
    c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_b_omega_C, 15U, c4_sf_marshallOut,
    c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_b_Demanded_torque, 16U,
    c4_sf_marshallOut, c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_b_Pitch_fine, 17U, c4_sf_marshallOut,
    c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_b_GenTorque, 18U, c4_sf_marshallOut,
    c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_b_RatedSpeed, 19U, c4_sf_marshallOut,
    c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_b_KillIntegrator, 20U,
    c4_sf_marshallOut, c4_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c4_b_Mode, 21U, c4_sf_marshallOut,
    c4_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 3);
  c4_aVarTruthTableCondition_1 = false;
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 4);
  c4_aVarTruthTableCondition_2 = false;
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 5);
  c4_aVarTruthTableCondition_3 = false;
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 6);
  c4_aVarTruthTableCondition_4 = false;
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 7);
  c4_aVarTruthTableCondition_5 = false;
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 8);
  c4_aVarTruthTableCondition_6 = false;
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 9);
  c4_aVarTruthTableCondition_7 = false;
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 14);
  c4_aVarTruthTableCondition_1 = (c4_b_GenSpeed < c4_const_omega_A);
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 18);
  c4_aVarTruthTableCondition_2 = (c4_b_GenSpeed < c4_b_omega_B *
    0.10471975511965977);
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 22);
  c4_aVarTruthTableCondition_3 = (c4_b_MeasTorque < c4_b_ModeGain * c4_b_omega_B
    * 0.10471975511965977 * c4_b_omega_B * 0.10471975511965977);
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 26);
  c4_aVarTruthTableCondition_4 = (c4_b_GenSpeed < c4_b_omega_C *
    0.10471975511965977);
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 30);
  c4_aVarTruthTableCondition_5 = (c4_b_MeasTorque < c4_b_ModeGain * c4_b_omega_C
    * 0.10471975511965977 * c4_b_omega_C * 0.10471975511965977);
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 34);
  c4_aVarTruthTableCondition_6 = (c4_b_MeasTorque < c4_b_Demanded_torque);
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 38);
  c4_aVarTruthTableCondition_7 = (c4_b_MeasPitch > c4_b_Pitch_fine * 1.05);
  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 40);
  if (CV_EML_IF(0, 1, 0, c4_aVarTruthTableCondition_1)) {
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 41);
    CV_EML_FCN(0, 1);
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 76);
    c4_b_RatedSpeed = c4_b_GenSpeed;
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 77);
    c4_b_GenTorque = 0.0;
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 78);
    c4_b_KillIntegrator = 0.0;
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 79);
    c4_b_Mode = 1.0;
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -79);
  } else {
    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 42);
    guard1 = false;
    guard2 = false;
    if (!CV_EML_COND(0, 1, 0, c4_aVarTruthTableCondition_1)) {
      if (CV_EML_COND(0, 1, 1, c4_aVarTruthTableCondition_2)) {
        if (CV_EML_COND(0, 1, 2, c4_aVarTruthTableCondition_3)) {
          CV_EML_MCDC(0, 1, 0, true);
          CV_EML_IF(0, 1, 1, true);
          _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 43);
          CV_EML_FCN(0, 2);
          _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 85);
          c4_b_RatedSpeed = c4_b_omega_B * 0.10471975511965977;
          _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 86);
          c4_b_GenTorque = c4_b_PrevTorque;
          _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 87);
          c4_b_KillIntegrator = 1.0;
          _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 88);
          c4_b_Mode = 2.0;
          _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -88);
        } else {
          guard1 = true;
        }
      } else {
        guard2 = true;
      }
    } else {
      guard2 = true;
    }

    if (guard2 == true) {
      guard1 = true;
    }

    if (guard1 == true) {
      CV_EML_MCDC(0, 1, 0, false);
      CV_EML_IF(0, 1, 1, false);
      _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 44);
      guard3 = false;
      guard4 = false;
      if (!CV_EML_COND(0, 1, 3, c4_aVarTruthTableCondition_1)) {
        if (CV_EML_COND(0, 1, 4, c4_aVarTruthTableCondition_2)) {
          if (!CV_EML_COND(0, 1, 5, c4_aVarTruthTableCondition_3)) {
            CV_EML_MCDC(0, 1, 1, true);
            CV_EML_IF(0, 1, 2, true);
            _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 45);
            CV_EML_FCN(0, 2);
            _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 85);
            c4_b_RatedSpeed = c4_b_omega_B * 0.10471975511965977;
            _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 86);
            c4_b_GenTorque = c4_b_PrevTorque;
            _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 87);
            c4_b_KillIntegrator = 1.0;
            _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 88);
            c4_b_Mode = 2.0;
            _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -88);
          } else {
            guard3 = true;
          }
        } else {
          guard4 = true;
        }
      } else {
        guard4 = true;
      }

      if (guard4 == true) {
        guard3 = true;
      }

      if (guard3 == true) {
        CV_EML_MCDC(0, 1, 1, false);
        CV_EML_IF(0, 1, 2, false);
        _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 46);
        guard5 = false;
        guard6 = false;
        guard7 = false;
        if (!CV_EML_COND(0, 1, 6, c4_aVarTruthTableCondition_1)) {
          if (!CV_EML_COND(0, 1, 7, c4_aVarTruthTableCondition_2)) {
            if (CV_EML_COND(0, 1, 8, c4_aVarTruthTableCondition_3)) {
              if (CV_EML_COND(0, 1, 9, c4_aVarTruthTableCondition_4)) {
                CV_EML_MCDC(0, 1, 2, true);
                CV_EML_IF(0, 1, 3, true);
                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 47);
                CV_EML_FCN(0, 2);
                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 85);
                c4_b_RatedSpeed = c4_b_omega_B * 0.10471975511965977;
                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 86);
                c4_b_GenTorque = c4_b_PrevTorque;
                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 87);
                c4_b_KillIntegrator = 1.0;
                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 88);
                c4_b_Mode = 2.0;
                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -88);
              } else {
                guard5 = true;
              }
            } else {
              guard6 = true;
            }
          } else {
            guard7 = true;
          }
        } else {
          guard7 = true;
        }

        if (guard7 == true) {
          guard6 = true;
        }

        if (guard6 == true) {
          guard5 = true;
        }

        if (guard5 == true) {
          CV_EML_MCDC(0, 1, 2, false);
          CV_EML_IF(0, 1, 3, false);
          _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 48);
          guard8 = false;
          guard9 = false;
          guard10 = false;
          if (!CV_EML_COND(0, 1, 10, c4_aVarTruthTableCondition_1)) {
            if (!CV_EML_COND(0, 1, 11, c4_aVarTruthTableCondition_2)) {
              if (CV_EML_COND(0, 1, 12, c4_aVarTruthTableCondition_3)) {
                if (!CV_EML_COND(0, 1, 13, c4_aVarTruthTableCondition_4)) {
                  CV_EML_MCDC(0, 1, 3, true);
                  CV_EML_IF(0, 1, 4, true);
                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 49);
                  CV_EML_FCN(0, 3);
                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 94);
                  c4_b_RatedSpeed = c4_b_GenSpeed;
                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 95);
                  c4_b_GenTorque = c4_b_ModeGain * c4_b_GenSpeed * c4_b_GenSpeed;
                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 96);
                  c4_b_KillIntegrator = 0.0;
                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 97);
                  c4_b_Mode = 3.0;
                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -97);
                } else {
                  guard8 = true;
                }
              } else {
                guard9 = true;
              }
            } else {
              guard10 = true;
            }
          } else {
            guard10 = true;
          }

          if (guard10 == true) {
            guard9 = true;
          }

          if (guard9 == true) {
            guard8 = true;
          }

          if (guard8 == true) {
            CV_EML_MCDC(0, 1, 3, false);
            CV_EML_IF(0, 1, 4, false);
            _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 50);
            guard11 = false;
            guard12 = false;
            guard13 = false;
            guard14 = false;
            if (!CV_EML_COND(0, 1, 14, c4_aVarTruthTableCondition_1)) {
              if (!CV_EML_COND(0, 1, 15, c4_aVarTruthTableCondition_2)) {
                if (!CV_EML_COND(0, 1, 16, c4_aVarTruthTableCondition_3)) {
                  if (CV_EML_COND(0, 1, 17, c4_aVarTruthTableCondition_4)) {
                    if (CV_EML_COND(0, 1, 18, c4_aVarTruthTableCondition_5)) {
                      CV_EML_MCDC(0, 1, 4, true);
                      CV_EML_IF(0, 1, 5, true);
                      _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 51);
                      CV_EML_FCN(0, 3);
                      _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 94);
                      c4_b_RatedSpeed = c4_b_GenSpeed;
                      _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 95);
                      c4_b_GenTorque = c4_b_ModeGain * c4_b_GenSpeed *
                        c4_b_GenSpeed;
                      _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 96);
                      c4_b_KillIntegrator = 0.0;
                      _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 97);
                      c4_b_Mode = 3.0;
                      _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -97);
                    } else {
                      guard11 = true;
                    }
                  } else {
                    guard12 = true;
                  }
                } else {
                  guard13 = true;
                }
              } else {
                guard14 = true;
              }
            } else {
              guard14 = true;
            }

            if (guard14 == true) {
              guard13 = true;
            }

            if (guard13 == true) {
              guard12 = true;
            }

            if (guard12 == true) {
              guard11 = true;
            }

            if (guard11 == true) {
              CV_EML_MCDC(0, 1, 4, false);
              CV_EML_IF(0, 1, 5, false);
              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 52);
              guard15 = false;
              guard16 = false;
              guard17 = false;
              guard18 = false;
              if (!CV_EML_COND(0, 1, 19, c4_aVarTruthTableCondition_1)) {
                if (!CV_EML_COND(0, 1, 20, c4_aVarTruthTableCondition_2)) {
                  if (!CV_EML_COND(0, 1, 21, c4_aVarTruthTableCondition_3)) {
                    if (!CV_EML_COND(0, 1, 22, c4_aVarTruthTableCondition_4)) {
                      if (CV_EML_COND(0, 1, 23, c4_aVarTruthTableCondition_5)) {
                        CV_EML_MCDC(0, 1, 5, true);
                        CV_EML_IF(0, 1, 6, true);
                        _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 53);
                        CV_EML_FCN(0, 4);
                        _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 103);
                        c4_b_RatedSpeed = c4_b_omega_C * 0.10471975511965977;
                        _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 104);
                        c4_b_GenTorque = c4_b_PrevTorque;
                        _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 105);
                        c4_b_KillIntegrator = 1.0;
                        _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 106);
                        c4_b_Mode = 4.0;
                        _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -106);
                      } else {
                        guard15 = true;
                      }
                    } else {
                      guard16 = true;
                    }
                  } else {
                    guard17 = true;
                  }
                } else {
                  guard18 = true;
                }
              } else {
                guard18 = true;
              }

              if (guard18 == true) {
                guard17 = true;
              }

              if (guard17 == true) {
                guard16 = true;
              }

              if (guard16 == true) {
                guard15 = true;
              }

              if (guard15 == true) {
                CV_EML_MCDC(0, 1, 5, false);
                CV_EML_IF(0, 1, 6, false);
                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 54);
                guard19 = false;
                guard20 = false;
                guard21 = false;
                guard22 = false;
                guard23 = false;
                guard24 = false;
                if (!CV_EML_COND(0, 1, 24, c4_aVarTruthTableCondition_1)) {
                  if (!CV_EML_COND(0, 1, 25, c4_aVarTruthTableCondition_2)) {
                    if (!CV_EML_COND(0, 1, 26, c4_aVarTruthTableCondition_3)) {
                      if (CV_EML_COND(0, 1, 27, c4_aVarTruthTableCondition_4)) {
                        if (!CV_EML_COND(0, 1, 28, c4_aVarTruthTableCondition_5))
                        {
                          if (CV_EML_COND(0, 1, 29, c4_aVarTruthTableCondition_6))
                          {
                            if (CV_EML_COND(0, 1, 30,
                                            c4_aVarTruthTableCondition_7)) {
                              CV_EML_MCDC(0, 1, 6, true);
                              CV_EML_IF(0, 1, 7, true);
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 55);
                              CV_EML_FCN(0, 4);
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 103);
                              c4_b_RatedSpeed = c4_b_omega_C *
                                0.10471975511965977;
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 104);
                              c4_b_GenTorque = c4_b_PrevTorque;
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 105);
                              c4_b_KillIntegrator = 1.0;
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 106);
                              c4_b_Mode = 4.0;
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -106);
                            } else {
                              guard19 = true;
                            }
                          } else {
                            guard20 = true;
                          }
                        } else {
                          guard21 = true;
                        }
                      } else {
                        guard22 = true;
                      }
                    } else {
                      guard23 = true;
                    }
                  } else {
                    guard24 = true;
                  }
                } else {
                  guard24 = true;
                }

                if (guard24 == true) {
                  guard23 = true;
                }

                if (guard23 == true) {
                  guard22 = true;
                }

                if (guard22 == true) {
                  guard21 = true;
                }

                if (guard21 == true) {
                  guard20 = true;
                }

                if (guard20 == true) {
                  guard19 = true;
                }

                if (guard19 == true) {
                  CV_EML_MCDC(0, 1, 6, false);
                  CV_EML_IF(0, 1, 7, false);
                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 56);
                  guard25 = false;
                  guard26 = false;
                  guard27 = false;
                  guard28 = false;
                  guard29 = false;
                  guard30 = false;
                  if (!CV_EML_COND(0, 1, 31, c4_aVarTruthTableCondition_1)) {
                    if (!CV_EML_COND(0, 1, 32, c4_aVarTruthTableCondition_2)) {
                      if (!CV_EML_COND(0, 1, 33, c4_aVarTruthTableCondition_3))
                      {
                        if (CV_EML_COND(0, 1, 34, c4_aVarTruthTableCondition_4))
                        {
                          if (!CV_EML_COND(0, 1, 35,
                                           c4_aVarTruthTableCondition_5)) {
                            if (CV_EML_COND(0, 1, 36,
                                            c4_aVarTruthTableCondition_6)) {
                              if (!CV_EML_COND(0, 1, 37,
                                               c4_aVarTruthTableCondition_7)) {
                                CV_EML_MCDC(0, 1, 7, true);
                                CV_EML_IF(0, 1, 8, true);
                                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 57);
                                CV_EML_FCN(0, 4);
                                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 103);
                                c4_b_RatedSpeed = c4_b_omega_C *
                                  0.10471975511965977;
                                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 104);
                                c4_b_GenTorque = c4_b_PrevTorque;
                                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 105);
                                c4_b_KillIntegrator = 1.0;
                                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 106);
                                c4_b_Mode = 4.0;
                                _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                              -106);
                              } else {
                                guard25 = true;
                              }
                            } else {
                              guard26 = true;
                            }
                          } else {
                            guard27 = true;
                          }
                        } else {
                          guard28 = true;
                        }
                      } else {
                        guard29 = true;
                      }
                    } else {
                      guard30 = true;
                    }
                  } else {
                    guard30 = true;
                  }

                  if (guard30 == true) {
                    guard29 = true;
                  }

                  if (guard29 == true) {
                    guard28 = true;
                  }

                  if (guard28 == true) {
                    guard27 = true;
                  }

                  if (guard27 == true) {
                    guard26 = true;
                  }

                  if (guard26 == true) {
                    guard25 = true;
                  }

                  if (guard25 == true) {
                    CV_EML_MCDC(0, 1, 7, false);
                    CV_EML_IF(0, 1, 8, false);
                    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 58);
                    guard31 = false;
                    guard32 = false;
                    guard33 = false;
                    guard34 = false;
                    guard35 = false;
                    guard36 = false;
                    if (!CV_EML_COND(0, 1, 38, c4_aVarTruthTableCondition_1)) {
                      if (!CV_EML_COND(0, 1, 39, c4_aVarTruthTableCondition_2))
                      {
                        if (!CV_EML_COND(0, 1, 40, c4_aVarTruthTableCondition_3))
                        {
                          if (CV_EML_COND(0, 1, 41, c4_aVarTruthTableCondition_4))
                          {
                            if (!CV_EML_COND(0, 1, 42,
                                             c4_aVarTruthTableCondition_5)) {
                              if (!CV_EML_COND(0, 1, 43,
                                               c4_aVarTruthTableCondition_6)) {
                                if (CV_EML_COND(0, 1, 44,
                                                c4_aVarTruthTableCondition_7)) {
                                  CV_EML_MCDC(0, 1, 8, true);
                                  CV_EML_IF(0, 1, 9, true);
                                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                59);
                                  CV_EML_FCN(0, 5);
                                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                112);
                                  c4_b_RatedSpeed = c4_b_GenSpeed;
                                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                113);
                                  c4_b_GenTorque = c4_b_Demanded_torque;
                                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                114);
                                  c4_b_KillIntegrator = 0.0;
                                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                115);
                                  c4_b_Mode = 5.0;
                                  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                -115);
                                } else {
                                  guard31 = true;
                                }
                              } else {
                                guard32 = true;
                              }
                            } else {
                              guard33 = true;
                            }
                          } else {
                            guard34 = true;
                          }
                        } else {
                          guard35 = true;
                        }
                      } else {
                        guard36 = true;
                      }
                    } else {
                      guard36 = true;
                    }

                    if (guard36 == true) {
                      guard35 = true;
                    }

                    if (guard35 == true) {
                      guard34 = true;
                    }

                    if (guard34 == true) {
                      guard33 = true;
                    }

                    if (guard33 == true) {
                      guard32 = true;
                    }

                    if (guard32 == true) {
                      guard31 = true;
                    }

                    if (guard31 == true) {
                      CV_EML_MCDC(0, 1, 8, false);
                      CV_EML_IF(0, 1, 9, false);
                      _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 60);
                      guard37 = false;
                      guard38 = false;
                      guard39 = false;
                      guard40 = false;
                      guard41 = false;
                      guard42 = false;
                      if (!CV_EML_COND(0, 1, 45, c4_aVarTruthTableCondition_1))
                      {
                        if (!CV_EML_COND(0, 1, 46, c4_aVarTruthTableCondition_2))
                        {
                          if (!CV_EML_COND(0, 1, 47,
                                           c4_aVarTruthTableCondition_3)) {
                            if (CV_EML_COND(0, 1, 48,
                                            c4_aVarTruthTableCondition_4)) {
                              if (!CV_EML_COND(0, 1, 49,
                                               c4_aVarTruthTableCondition_5)) {
                                if (!CV_EML_COND(0, 1, 50,
                                                 c4_aVarTruthTableCondition_6))
                                {
                                  if (!CV_EML_COND(0, 1, 51,
                                                   c4_aVarTruthTableCondition_7))
                                  {
                                    CV_EML_MCDC(0, 1, 9, true);
                                    CV_EML_IF(0, 1, 10, true);
                                    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                  61);
                                    CV_EML_FCN(0, 4);
                                    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                  103);
                                    c4_b_RatedSpeed = c4_b_omega_C *
                                      0.10471975511965977;
                                    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                  104);
                                    c4_b_GenTorque = c4_b_PrevTorque;
                                    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                  105);
                                    c4_b_KillIntegrator = 1.0;
                                    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                  106);
                                    c4_b_Mode = 4.0;
                                    _SFD_EML_CALL(0U, chartInstance->c4_sfEvent,
                                                  -106);
                                  } else {
                                    guard37 = true;
                                  }
                                } else {
                                  guard38 = true;
                                }
                              } else {
                                guard39 = true;
                              }
                            } else {
                              guard40 = true;
                            }
                          } else {
                            guard41 = true;
                          }
                        } else {
                          guard42 = true;
                        }
                      } else {
                        guard42 = true;
                      }

                      if (guard42 == true) {
                        guard41 = true;
                      }

                      if (guard41 == true) {
                        guard40 = true;
                      }

                      if (guard40 == true) {
                        guard39 = true;
                      }

                      if (guard39 == true) {
                        guard38 = true;
                      }

                      if (guard38 == true) {
                        guard37 = true;
                      }

                      if (guard37 == true) {
                        CV_EML_MCDC(0, 1, 9, false);
                        CV_EML_IF(0, 1, 10, false);
                        _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 62);
                        guard43 = false;
                        guard44 = false;
                        guard45 = false;
                        guard46 = false;
                        guard47 = false;
                        guard48 = false;
                        if (!CV_EML_COND(0, 1, 52, c4_aVarTruthTableCondition_1))
                        {
                          if (!CV_EML_COND(0, 1, 53,
                                           c4_aVarTruthTableCondition_2)) {
                            if (!CV_EML_COND(0, 1, 54,
                                             c4_aVarTruthTableCondition_3)) {
                              if (!CV_EML_COND(0, 1, 55,
                                               c4_aVarTruthTableCondition_4)) {
                                if (!CV_EML_COND(0, 1, 56,
                                                 c4_aVarTruthTableCondition_5))
                                {
                                  if (CV_EML_COND(0, 1, 57,
                                                  c4_aVarTruthTableCondition_6))
                                  {
                                    if (CV_EML_COND(0, 1, 58,
                                                    c4_aVarTruthTableCondition_7))
                                    {
                                      CV_EML_MCDC(0, 1, 10, true);
                                      CV_EML_IF(0, 1, 11, true);
                                      _SFD_EML_CALL(0U,
                                                    chartInstance->c4_sfEvent,
                                                    63);
                                      CV_EML_FCN(0, 5);
                                      _SFD_EML_CALL(0U,
                                                    chartInstance->c4_sfEvent,
                                                    112);
                                      c4_b_RatedSpeed = c4_b_GenSpeed;
                                      _SFD_EML_CALL(0U,
                                                    chartInstance->c4_sfEvent,
                                                    113);
                                      c4_b_GenTorque = c4_b_Demanded_torque;
                                      _SFD_EML_CALL(0U,
                                                    chartInstance->c4_sfEvent,
                                                    114);
                                      c4_b_KillIntegrator = 0.0;
                                      _SFD_EML_CALL(0U,
                                                    chartInstance->c4_sfEvent,
                                                    115);
                                      c4_b_Mode = 5.0;
                                      _SFD_EML_CALL(0U,
                                                    chartInstance->c4_sfEvent,
                                                    -115);
                                    } else {
                                      guard43 = true;
                                    }
                                  } else {
                                    guard44 = true;
                                  }
                                } else {
                                  guard45 = true;
                                }
                              } else {
                                guard46 = true;
                              }
                            } else {
                              guard47 = true;
                            }
                          } else {
                            guard48 = true;
                          }
                        } else {
                          guard48 = true;
                        }

                        if (guard48 == true) {
                          guard47 = true;
                        }

                        if (guard47 == true) {
                          guard46 = true;
                        }

                        if (guard46 == true) {
                          guard45 = true;
                        }

                        if (guard45 == true) {
                          guard44 = true;
                        }

                        if (guard44 == true) {
                          guard43 = true;
                        }

                        if (guard43 == true) {
                          CV_EML_MCDC(0, 1, 10, false);
                          CV_EML_IF(0, 1, 11, false);
                          _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 64);
                          guard49 = false;
                          guard50 = false;
                          guard51 = false;
                          guard52 = false;
                          guard53 = false;
                          guard54 = false;
                          if (!CV_EML_COND(0, 1, 59,
                                           c4_aVarTruthTableCondition_1)) {
                            if (!CV_EML_COND(0, 1, 60,
                                             c4_aVarTruthTableCondition_2)) {
                              if (!CV_EML_COND(0, 1, 61,
                                               c4_aVarTruthTableCondition_3)) {
                                if (!CV_EML_COND(0, 1, 62,
                                                 c4_aVarTruthTableCondition_4))
                                {
                                  if (!CV_EML_COND(0, 1, 63,
                                                   c4_aVarTruthTableCondition_5))
                                  {
                                    if (CV_EML_COND(0, 1, 64,
                                                    c4_aVarTruthTableCondition_6))
                                    {
                                      if (!CV_EML_COND(0, 1, 65,
                                                       c4_aVarTruthTableCondition_7))
                                      {
                                        CV_EML_MCDC(0, 1, 11, true);
                                        CV_EML_IF(0, 1, 12, true);
                                        _SFD_EML_CALL(0U,
                                                      chartInstance->c4_sfEvent,
                                                      65);
                                        CV_EML_FCN(0, 4);
                                        _SFD_EML_CALL(0U,
                                                      chartInstance->c4_sfEvent,
                                                      103);
                                        c4_b_RatedSpeed = c4_b_omega_C *
                                          0.10471975511965977;
                                        _SFD_EML_CALL(0U,
                                                      chartInstance->c4_sfEvent,
                                                      104);
                                        c4_b_GenTorque = c4_b_PrevTorque;
                                        _SFD_EML_CALL(0U,
                                                      chartInstance->c4_sfEvent,
                                                      105);
                                        c4_b_KillIntegrator = 1.0;
                                        _SFD_EML_CALL(0U,
                                                      chartInstance->c4_sfEvent,
                                                      106);
                                        c4_b_Mode = 4.0;
                                        _SFD_EML_CALL(0U,
                                                      chartInstance->c4_sfEvent,
                                                      -106);
                                      } else {
                                        guard49 = true;
                                      }
                                    } else {
                                      guard50 = true;
                                    }
                                  } else {
                                    guard51 = true;
                                  }
                                } else {
                                  guard52 = true;
                                }
                              } else {
                                guard53 = true;
                              }
                            } else {
                              guard54 = true;
                            }
                          } else {
                            guard54 = true;
                          }

                          if (guard54 == true) {
                            guard53 = true;
                          }

                          if (guard53 == true) {
                            guard52 = true;
                          }

                          if (guard52 == true) {
                            guard51 = true;
                          }

                          if (guard51 == true) {
                            guard50 = true;
                          }

                          if (guard50 == true) {
                            guard49 = true;
                          }

                          if (guard49 == true) {
                            CV_EML_MCDC(0, 1, 11, false);
                            CV_EML_IF(0, 1, 12, false);
                            _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 66);
                            guard55 = false;
                            guard56 = false;
                            guard57 = false;
                            guard58 = false;
                            guard59 = false;
                            guard60 = false;
                            if (!CV_EML_COND(0, 1, 66,
                                             c4_aVarTruthTableCondition_1)) {
                              if (!CV_EML_COND(0, 1, 67,
                                               c4_aVarTruthTableCondition_2)) {
                                if (!CV_EML_COND(0, 1, 68,
                                                 c4_aVarTruthTableCondition_3))
                                {
                                  if (!CV_EML_COND(0, 1, 69,
                                                   c4_aVarTruthTableCondition_4))
                                  {
                                    if (!CV_EML_COND(0, 1, 70,
                                                     c4_aVarTruthTableCondition_5))
                                    {
                                      if (!CV_EML_COND(0, 1, 71,
                                                       c4_aVarTruthTableCondition_6))
                                      {
                                        if (CV_EML_COND(0, 1, 72,
                                                        c4_aVarTruthTableCondition_7))
                                        {
                                          CV_EML_MCDC(0, 1, 12, true);
                                          CV_EML_IF(0, 1, 13, true);
                                          _SFD_EML_CALL(0U,
                                                        chartInstance->c4_sfEvent,
                                                        67);
                                          CV_EML_FCN(0, 5);
                                          _SFD_EML_CALL(0U,
                                                        chartInstance->c4_sfEvent,
                                                        112);
                                          c4_b_RatedSpeed = c4_b_GenSpeed;
                                          _SFD_EML_CALL(0U,
                                                        chartInstance->c4_sfEvent,
                                                        113);
                                          c4_b_GenTorque = c4_b_Demanded_torque;
                                          _SFD_EML_CALL(0U,
                                                        chartInstance->c4_sfEvent,
                                                        114);
                                          c4_b_KillIntegrator = 0.0;
                                          _SFD_EML_CALL(0U,
                                                        chartInstance->c4_sfEvent,
                                                        115);
                                          c4_b_Mode = 5.0;
                                          _SFD_EML_CALL(0U,
                                                        chartInstance->c4_sfEvent,
                                                        -115);
                                        } else {
                                          guard55 = true;
                                        }
                                      } else {
                                        guard56 = true;
                                      }
                                    } else {
                                      guard57 = true;
                                    }
                                  } else {
                                    guard58 = true;
                                  }
                                } else {
                                  guard59 = true;
                                }
                              } else {
                                guard60 = true;
                              }
                            } else {
                              guard60 = true;
                            }

                            if (guard60 == true) {
                              guard59 = true;
                            }

                            if (guard59 == true) {
                              guard58 = true;
                            }

                            if (guard58 == true) {
                              guard57 = true;
                            }

                            if (guard57 == true) {
                              guard56 = true;
                            }

                            if (guard56 == true) {
                              guard55 = true;
                            }

                            if (guard55 == true) {
                              CV_EML_MCDC(0, 1, 12, false);
                              CV_EML_IF(0, 1, 13, false);
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 69);
                              CV_EML_FCN(0, 5);
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 112);
                              c4_b_RatedSpeed = c4_b_GenSpeed;
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 113);
                              c4_b_GenTorque = c4_b_Demanded_torque;
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 114);
                              c4_b_KillIntegrator = 0.0;
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, 115);
                              c4_b_Mode = 5.0;
                              _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -115);
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  _SFD_EML_CALL(0U, chartInstance->c4_sfEvent, -69);
  _SFD_SYMBOL_SCOPE_POP();
  *chartInstance->c4_GenTorque = c4_b_GenTorque;
  *chartInstance->c4_RatedSpeed = c4_b_RatedSpeed;
  *chartInstance->c4_KillIntegrator = c4_b_KillIntegrator;
  *chartInstance->c4_Mode = c4_b_Mode;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 3U, chartInstance->c4_sfEvent);
}

static void initSimStructsc4_NREL5MW_Baseline_loads_2014b
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  (void)chartInstance;
}

static void init_script_number_translation(uint32_T c4_machineNumber, uint32_T
  c4_chartNumber, uint32_T c4_instanceNumber)
{
  (void)c4_machineNumber;
  (void)c4_chartNumber;
  (void)c4_instanceNumber;
}

static const mxArray *c4_sf_marshallOut(void *chartInstanceVoid, void *c4_inData)
{
  const mxArray *c4_mxArrayOutData = NULL;
  real_T c4_u;
  const mxArray *c4_y = NULL;
  SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance;
  chartInstance = (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *)
    chartInstanceVoid;
  c4_mxArrayOutData = NULL;
  c4_u = *(real_T *)c4_inData;
  c4_y = NULL;
  sf_mex_assign(&c4_y, sf_mex_create("y", &c4_u, 0, 0U, 0U, 0U, 0), false);
  sf_mex_assign(&c4_mxArrayOutData, c4_y, false);
  return c4_mxArrayOutData;
}

static real_T c4_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_b_Mode, const char_T *c4_identifier)
{
  real_T c4_y;
  emlrtMsgIdentifier c4_thisId;
  c4_thisId.fIdentifier = c4_identifier;
  c4_thisId.fParent = NULL;
  c4_y = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c4_b_Mode), &c4_thisId);
  sf_mex_destroy(&c4_b_Mode);
  return c4_y;
}

static real_T c4_b_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
  real_T c4_y;
  real_T c4_d4;
  (void)chartInstance;
  sf_mex_import(c4_parentId, sf_mex_dup(c4_u), &c4_d4, 1, 0, 0U, 0, 0U, 0);
  c4_y = c4_d4;
  sf_mex_destroy(&c4_u);
  return c4_y;
}

static void c4_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData)
{
  const mxArray *c4_b_Mode;
  const char_T *c4_identifier;
  emlrtMsgIdentifier c4_thisId;
  real_T c4_y;
  SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance;
  chartInstance = (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *)
    chartInstanceVoid;
  c4_b_Mode = sf_mex_dup(c4_mxArrayInData);
  c4_identifier = c4_varName;
  c4_thisId.fIdentifier = c4_identifier;
  c4_thisId.fParent = NULL;
  c4_y = c4_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c4_b_Mode), &c4_thisId);
  sf_mex_destroy(&c4_b_Mode);
  *(real_T *)c4_outData = c4_y;
  sf_mex_destroy(&c4_mxArrayInData);
}

static const mxArray *c4_b_sf_marshallOut(void *chartInstanceVoid, void
  *c4_inData)
{
  const mxArray *c4_mxArrayOutData = NULL;
  boolean_T c4_u;
  const mxArray *c4_y = NULL;
  SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance;
  chartInstance = (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *)
    chartInstanceVoid;
  c4_mxArrayOutData = NULL;
  c4_u = *(boolean_T *)c4_inData;
  c4_y = NULL;
  sf_mex_assign(&c4_y, sf_mex_create("y", &c4_u, 11, 0U, 0U, 0U, 0), false);
  sf_mex_assign(&c4_mxArrayOutData, c4_y, false);
  return c4_mxArrayOutData;
}

static boolean_T c4_c_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
  boolean_T c4_y;
  boolean_T c4_b0;
  (void)chartInstance;
  sf_mex_import(c4_parentId, sf_mex_dup(c4_u), &c4_b0, 1, 11, 0U, 0, 0U, 0);
  c4_y = c4_b0;
  sf_mex_destroy(&c4_u);
  return c4_y;
}

static void c4_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData)
{
  const mxArray *c4_aVarTruthTableCondition_7;
  const char_T *c4_identifier;
  emlrtMsgIdentifier c4_thisId;
  boolean_T c4_y;
  SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance;
  chartInstance = (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *)
    chartInstanceVoid;
  c4_aVarTruthTableCondition_7 = sf_mex_dup(c4_mxArrayInData);
  c4_identifier = c4_varName;
  c4_thisId.fIdentifier = c4_identifier;
  c4_thisId.fParent = NULL;
  c4_y = c4_c_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c4_aVarTruthTableCondition_7), &c4_thisId);
  sf_mex_destroy(&c4_aVarTruthTableCondition_7);
  *(boolean_T *)c4_outData = c4_y;
  sf_mex_destroy(&c4_mxArrayInData);
}

const mxArray
  *sf_c4_NREL5MW_Baseline_loads_2014b_get_eml_resolved_functions_info(void)
{
  const mxArray *c4_nameCaptureInfo = NULL;
  c4_nameCaptureInfo = NULL;
  sf_mex_assign(&c4_nameCaptureInfo, sf_mex_createstruct("structure", 2, 7, 1),
                false);
  c4_info_helper(&c4_nameCaptureInfo);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c4_nameCaptureInfo);
  return c4_nameCaptureInfo;
}

static void c4_info_helper(const mxArray **c4_info)
{
  const mxArray *c4_rhs0 = NULL;
  const mxArray *c4_lhs0 = NULL;
  const mxArray *c4_rhs1 = NULL;
  const mxArray *c4_lhs1 = NULL;
  const mxArray *c4_rhs2 = NULL;
  const mxArray *c4_lhs2 = NULL;
  const mxArray *c4_rhs3 = NULL;
  const mxArray *c4_lhs3 = NULL;
  const mxArray *c4_rhs4 = NULL;
  const mxArray *c4_lhs4 = NULL;
  const mxArray *c4_rhs5 = NULL;
  const mxArray *c4_lhs5 = NULL;
  const mxArray *c4_rhs6 = NULL;
  const mxArray *c4_lhs6 = NULL;
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(""), "context", "context", 0);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("mrdivide"), "name", "name", 0);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("double"), "dominantType",
                  "dominantType", 0);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p"), "resolved",
                  "resolved", 0);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(1410807648U), "fileTimeLo",
                  "fileTimeLo", 0);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "fileTimeHi",
                  "fileTimeHi", 0);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(1370009886U), "mFileTimeLo",
                  "mFileTimeLo", 0);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeHi",
                  "mFileTimeHi", 0);
  sf_mex_assign(&c4_rhs0, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_assign(&c4_lhs0, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_rhs0), "rhs", "rhs", 0);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_lhs0), "lhs", "lhs", 0);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p"), "context",
                  "context", 1);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("coder.internal.assert"),
                  "name", "name", 1);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("char"), "dominantType",
                  "dominantType", 1);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/assert.m"),
                  "resolved", "resolved", 1);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(1389717774U), "fileTimeLo",
                  "fileTimeLo", 1);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "fileTimeHi",
                  "fileTimeHi", 1);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeLo",
                  "mFileTimeLo", 1);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeHi",
                  "mFileTimeHi", 1);
  sf_mex_assign(&c4_rhs1, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_assign(&c4_lhs1, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_rhs1), "rhs", "rhs", 1);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_lhs1), "lhs", "lhs", 1);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p"), "context",
                  "context", 2);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("rdivide"), "name", "name", 2);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("double"), "dominantType",
                  "dominantType", 2);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m"), "resolved",
                  "resolved", 2);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(1363713880U), "fileTimeLo",
                  "fileTimeLo", 2);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "fileTimeHi",
                  "fileTimeHi", 2);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeLo",
                  "mFileTimeLo", 2);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeHi",
                  "mFileTimeHi", 2);
  sf_mex_assign(&c4_rhs2, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_assign(&c4_lhs2, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_rhs2), "rhs", "rhs", 2);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_lhs2), "lhs", "lhs", 2);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m"), "context",
                  "context", 3);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "coder.internal.isBuiltInNumeric"), "name", "name", 3);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("double"), "dominantType",
                  "dominantType", 3);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/isBuiltInNumeric.m"),
                  "resolved", "resolved", 3);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(1395931856U), "fileTimeLo",
                  "fileTimeLo", 3);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "fileTimeHi",
                  "fileTimeHi", 3);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeLo",
                  "mFileTimeLo", 3);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeHi",
                  "mFileTimeHi", 3);
  sf_mex_assign(&c4_rhs3, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_assign(&c4_lhs3, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_rhs3), "rhs", "rhs", 3);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_lhs3), "lhs", "lhs", 3);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m"), "context",
                  "context", 4);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("eml_scalexp_compatible"),
                  "name", "name", 4);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("double"), "dominantType",
                  "dominantType", 4);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_compatible.m"),
                  "resolved", "resolved", 4);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(1286818796U), "fileTimeLo",
                  "fileTimeLo", 4);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "fileTimeHi",
                  "fileTimeHi", 4);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeLo",
                  "mFileTimeLo", 4);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeHi",
                  "mFileTimeHi", 4);
  sf_mex_assign(&c4_rhs4, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_assign(&c4_lhs4, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_rhs4), "rhs", "rhs", 4);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_lhs4), "lhs", "lhs", 4);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m"), "context",
                  "context", 5);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("eml_div"), "name", "name", 5);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("double"), "dominantType",
                  "dominantType", 5);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m"), "resolved",
                  "resolved", 5);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(1386423952U), "fileTimeLo",
                  "fileTimeLo", 5);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "fileTimeHi",
                  "fileTimeHi", 5);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeLo",
                  "mFileTimeLo", 5);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeHi",
                  "mFileTimeHi", 5);
  sf_mex_assign(&c4_rhs5, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_assign(&c4_lhs5, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_rhs5), "rhs", "rhs", 5);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_lhs5), "lhs", "lhs", 5);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m"), "context",
                  "context", 6);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("coder.internal.div"), "name",
                  "name", 6);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut("double"), "dominantType",
                  "dominantType", 6);
  sf_mex_addfield(*c4_info, c4_emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/coder/coder/+coder/+internal/div.p"), "resolved",
                  "resolved", 6);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(1410807770U), "fileTimeLo",
                  "fileTimeLo", 6);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "fileTimeHi",
                  "fileTimeHi", 6);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeLo",
                  "mFileTimeLo", 6);
  sf_mex_addfield(*c4_info, c4_b_emlrt_marshallOut(0U), "mFileTimeHi",
                  "mFileTimeHi", 6);
  sf_mex_assign(&c4_rhs6, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_assign(&c4_lhs6, sf_mex_createcellmatrix(0, 1), false);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_rhs6), "rhs", "rhs", 6);
  sf_mex_addfield(*c4_info, sf_mex_duplicatearraysafe(&c4_lhs6), "lhs", "lhs", 6);
  sf_mex_destroy(&c4_rhs0);
  sf_mex_destroy(&c4_lhs0);
  sf_mex_destroy(&c4_rhs1);
  sf_mex_destroy(&c4_lhs1);
  sf_mex_destroy(&c4_rhs2);
  sf_mex_destroy(&c4_lhs2);
  sf_mex_destroy(&c4_rhs3);
  sf_mex_destroy(&c4_lhs3);
  sf_mex_destroy(&c4_rhs4);
  sf_mex_destroy(&c4_lhs4);
  sf_mex_destroy(&c4_rhs5);
  sf_mex_destroy(&c4_lhs5);
  sf_mex_destroy(&c4_rhs6);
  sf_mex_destroy(&c4_lhs6);
}

static const mxArray *c4_emlrt_marshallOut(const char * c4_u)
{
  const mxArray *c4_y = NULL;
  c4_y = NULL;
  sf_mex_assign(&c4_y, sf_mex_create("y", c4_u, 15, 0U, 0U, 0U, 2, 1, strlen
    (c4_u)), false);
  return c4_y;
}

static const mxArray *c4_b_emlrt_marshallOut(const uint32_T c4_u)
{
  const mxArray *c4_y = NULL;
  c4_y = NULL;
  sf_mex_assign(&c4_y, sf_mex_create("y", &c4_u, 7, 0U, 0U, 0U, 0), false);
  return c4_y;
}

static const mxArray *c4_c_sf_marshallOut(void *chartInstanceVoid, void
  *c4_inData)
{
  const mxArray *c4_mxArrayOutData = NULL;
  int32_T c4_u;
  const mxArray *c4_y = NULL;
  SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance;
  chartInstance = (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *)
    chartInstanceVoid;
  c4_mxArrayOutData = NULL;
  c4_u = *(int32_T *)c4_inData;
  c4_y = NULL;
  sf_mex_assign(&c4_y, sf_mex_create("y", &c4_u, 6, 0U, 0U, 0U, 0), false);
  sf_mex_assign(&c4_mxArrayOutData, c4_y, false);
  return c4_mxArrayOutData;
}

static int32_T c4_d_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
  int32_T c4_y;
  int32_T c4_i0;
  (void)chartInstance;
  sf_mex_import(c4_parentId, sf_mex_dup(c4_u), &c4_i0, 1, 6, 0U, 0, 0U, 0);
  c4_y = c4_i0;
  sf_mex_destroy(&c4_u);
  return c4_y;
}

static void c4_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c4_mxArrayInData, const char_T *c4_varName, void *c4_outData)
{
  const mxArray *c4_b_sfEvent;
  const char_T *c4_identifier;
  emlrtMsgIdentifier c4_thisId;
  int32_T c4_y;
  SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance;
  chartInstance = (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *)
    chartInstanceVoid;
  c4_b_sfEvent = sf_mex_dup(c4_mxArrayInData);
  c4_identifier = c4_varName;
  c4_thisId.fIdentifier = c4_identifier;
  c4_thisId.fParent = NULL;
  c4_y = c4_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c4_b_sfEvent),
    &c4_thisId);
  sf_mex_destroy(&c4_b_sfEvent);
  *(int32_T *)c4_outData = c4_y;
  sf_mex_destroy(&c4_mxArrayInData);
}

static uint8_T c4_e_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_b_is_active_c4_NREL5MW_Baseline_loads_2014b, const char_T *c4_identifier)
{
  uint8_T c4_y;
  emlrtMsgIdentifier c4_thisId;
  c4_thisId.fIdentifier = c4_identifier;
  c4_thisId.fParent = NULL;
  c4_y = c4_f_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c4_b_is_active_c4_NREL5MW_Baseline_loads_2014b), &c4_thisId);
  sf_mex_destroy(&c4_b_is_active_c4_NREL5MW_Baseline_loads_2014b);
  return c4_y;
}

static uint8_T c4_f_emlrt_marshallIn
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance, const mxArray
   *c4_u, const emlrtMsgIdentifier *c4_parentId)
{
  uint8_T c4_y;
  uint8_T c4_u0;
  (void)chartInstance;
  sf_mex_import(c4_parentId, sf_mex_dup(c4_u), &c4_u0, 1, 3, 0U, 0, 0U, 0);
  c4_y = c4_u0;
  sf_mex_destroy(&c4_u);
  return c4_y;
}

static void init_dsm_address_info
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  (void)chartInstance;
}

static void init_simulink_io_address
  (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance)
{
  chartInstance->c4_PrevTorque = (real_T *)ssGetInputPortSignal_wrapper
    (chartInstance->S, 0);
  chartInstance->c4_MeasTorque = (real_T *)ssGetInputPortSignal_wrapper
    (chartInstance->S, 1);
  chartInstance->c4_MeasPitch = (real_T *)ssGetInputPortSignal_wrapper
    (chartInstance->S, 2);
  chartInstance->c4_ModeGain = (real_T *)ssGetInputPortSignal_wrapper
    (chartInstance->S, 3);
  chartInstance->c4_GenSpeed = (real_T *)ssGetInputPortSignal_wrapper
    (chartInstance->S, 4);
  chartInstance->c4_GenTorque = (real_T *)ssGetOutputPortSignal_wrapper
    (chartInstance->S, 1);
  chartInstance->c4_RatedSpeed = (real_T *)ssGetOutputPortSignal_wrapper
    (chartInstance->S, 2);
  chartInstance->c4_KillIntegrator = (real_T *)ssGetOutputPortSignal_wrapper
    (chartInstance->S, 3);
  chartInstance->c4_Mode = (real_T *)ssGetOutputPortSignal_wrapper
    (chartInstance->S, 4);
}

/* SFunction Glue Code */
#ifdef utFree
#undef utFree
#endif

#ifdef utMalloc
#undef utMalloc
#endif

#ifdef __cplusplus

extern "C" void *utMalloc(size_t size);
extern "C" void utFree(void*);

#else

extern void *utMalloc(size_t size);
extern void utFree(void*);

#endif

void sf_c4_NREL5MW_Baseline_loads_2014b_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(4065065225U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(2298693041U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1476309210U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(287048254U);
}

mxArray* sf_c4_NREL5MW_Baseline_loads_2014b_get_post_codegen_info(void);
mxArray *sf_c4_NREL5MW_Baseline_loads_2014b_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals", "postCodegenInfo" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1, 1, sizeof
    (autoinheritanceFields)/sizeof(autoinheritanceFields[0]),
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("gqddKpoupFVsyXzayQBF5F");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,5,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,3,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,3,"type",mxType);
    }

    mxSetField(mxData,3,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,4,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,4,"type",mxType);
    }

    mxSetField(mxData,4,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,4,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,3,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,3,"type",mxType);
    }

    mxSetField(mxData,3,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxData);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,4,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,3,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,3,"type",mxType);
    }

    mxSetField(mxData,3,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  {
    mxArray* mxPostCodegenInfo =
      sf_c4_NREL5MW_Baseline_loads_2014b_get_post_codegen_info();
    mxSetField(mxAutoinheritanceInfo,0,"postCodegenInfo",mxPostCodegenInfo);
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c4_NREL5MW_Baseline_loads_2014b_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

mxArray *sf_c4_NREL5MW_Baseline_loads_2014b_jit_fallback_info(void)
{
  const char *infoFields[] = { "fallbackType", "fallbackReason",
    "incompatibleSymbol", };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 3, infoFields);
  mxArray *fallbackReason = mxCreateString("feature_off");
  mxArray *incompatibleSymbol = mxCreateString("");
  mxArray *fallbackType = mxCreateString("early");
  mxSetField(mxInfo, 0, infoFields[0], fallbackType);
  mxSetField(mxInfo, 0, infoFields[1], fallbackReason);
  mxSetField(mxInfo, 0, infoFields[2], incompatibleSymbol);
  return mxInfo;
}

mxArray *sf_c4_NREL5MW_Baseline_loads_2014b_updateBuildInfo_args_info(void)
{
  mxArray *mxBIArgs = mxCreateCellMatrix(1,0);
  return mxBIArgs;
}

mxArray* sf_c4_NREL5MW_Baseline_loads_2014b_get_post_codegen_info(void)
{
  const char* fieldNames[] = { "exportedFunctionsUsedByThisChart",
    "exportedFunctionsChecksum" };

  mwSize dims[2] = { 1, 1 };

  mxArray* mxPostCodegenInfo = mxCreateStructArray(2, dims, sizeof(fieldNames)/
    sizeof(fieldNames[0]), fieldNames);

  {
    mxArray* mxExportedFunctionsChecksum = mxCreateString("");
    mwSize exp_dims[2] = { 0, 1 };

    mxArray* mxExportedFunctionsUsedByThisChart = mxCreateCellArray(2, exp_dims);
    mxSetField(mxPostCodegenInfo, 0, "exportedFunctionsUsedByThisChart",
               mxExportedFunctionsUsedByThisChart);
    mxSetField(mxPostCodegenInfo, 0, "exportedFunctionsChecksum",
               mxExportedFunctionsChecksum);
  }

  return mxPostCodegenInfo;
}

static const mxArray *sf_get_sim_state_info_c4_NREL5MW_Baseline_loads_2014b(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x5'type','srcId','name','auxInfo'{{M[1],M[5],T\"GenTorque\",},{M[1],M[11],T\"KillIntegrator\",},{M[1],M[18],T\"Mode\",},{M[1],M[9],T\"RatedSpeed\",},{M[8],M[0],T\"is_active_c4_NREL5MW_Baseline_loads_2014b\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 5, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c4_NREL5MW_Baseline_loads_2014b_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance;
    ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
    ChartInfoStruct * chartInfo = (ChartInfoStruct *)(crtInfo->instanceInfo);
    chartInstance = (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *)
      chartInfo->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _NREL5MW_Baseline_loads_2014bMachineNumber_,
           4,
           1,
           1,
           0,
           14,
           0,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           (void *)S);

        /* Each instance must initialize its own list of scripts */
        init_script_number_translation
          (_NREL5MW_Baseline_loads_2014bMachineNumber_,
           chartInstance->chartNumber,chartInstance->instanceNumber);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          sf_debug_set_chart_disable_implicit_casting
            (sfGlobalDebugInstanceStruct,
             _NREL5MW_Baseline_loads_2014bMachineNumber_,
             chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(sfGlobalDebugInstanceStruct,
            _NREL5MW_Baseline_loads_2014bMachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"PrevTorque");
          _SFD_SET_DATA_PROPS(1,1,1,0,"MeasTorque");
          _SFD_SET_DATA_PROPS(2,1,1,0,"MeasPitch");
          _SFD_SET_DATA_PROPS(3,1,1,0,"ModeGain");
          _SFD_SET_DATA_PROPS(4,1,1,0,"GenSpeed");
          _SFD_SET_DATA_PROPS(5,2,0,1,"GenTorque");
          _SFD_SET_DATA_PROPS(6,2,0,1,"RatedSpeed");
          _SFD_SET_DATA_PROPS(7,2,0,1,"KillIntegrator");
          _SFD_SET_DATA_PROPS(8,7,0,0,"omega_A");
          _SFD_SET_DATA_PROPS(9,10,0,0,"omega_B");
          _SFD_SET_DATA_PROPS(10,10,0,0,"omega_C");
          _SFD_SET_DATA_PROPS(11,10,0,0,"Demanded_torque");
          _SFD_SET_DATA_PROPS(12,2,0,1,"Mode");
          _SFD_SET_DATA_PROPS(13,10,0,0,"Pitch_fine");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,6,14,0,0,0,0,0,73,13);
        _SFD_CV_INIT_EML_FCN(0,0,"tt_blk_kernel",0,-1,3795);
        _SFD_CV_INIT_EML_FCN(0,1,"aFcnTruthTableAction_1",3795,-1,3913);
        _SFD_CV_INIT_EML_FCN(0,2,"aFcnTruthTableAction_2",3913,-1,4047);
        _SFD_CV_INIT_EML_FCN(0,3,"aFcnTruthTableAction_3",4047,-1,4188);
        _SFD_CV_INIT_EML_FCN(0,4,"aFcnTruthTableAction_4",4188,-1,4322);
        _SFD_CV_INIT_EML_FCN(0,5,"aFcnTruthTableAction_5",4322,-1,4449);
        _SFD_CV_INIT_EML_IF(0,1,0,1047,1077,1108,3793);
        _SFD_CV_INIT_EML_IF(0,1,1,1108,1201,1232,3793);
        _SFD_CV_INIT_EML_IF(0,1,2,1232,1326,1357,3793);
        _SFD_CV_INIT_EML_IF(0,1,3,1357,1480,1511,3793);
        _SFD_CV_INIT_EML_IF(0,1,4,1511,1635,1666,3793);
        _SFD_CV_INIT_EML_IF(0,1,5,1666,1819,1850,3793);
        _SFD_CV_INIT_EML_IF(0,1,6,1850,2004,2035,3793);
        _SFD_CV_INIT_EML_IF(0,1,7,2035,2247,2278,3793);
        _SFD_CV_INIT_EML_IF(0,1,8,2278,2491,2522,3793);
        _SFD_CV_INIT_EML_IF(0,1,9,2522,2735,2766,3793);
        _SFD_CV_INIT_EML_IF(0,1,10,2766,2980,3011,3793);
        _SFD_CV_INIT_EML_IF(0,1,11,3011,3224,3255,3793);
        _SFD_CV_INIT_EML_IF(0,1,12,3255,3469,3500,3793);
        _SFD_CV_INIT_EML_IF(0,1,13,3500,3714,3745,3793);

        {
          static int condStart[] = { 1117, 1146, 1175 };

          static int condEnd[] = { 1142, 1171, 1200 };

          static int pfixExpr[] = { 0, -1, 1, -3, 2, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,0,1116,1200,3,0,&(condStart[0]),&(condEnd[0]),
                                6,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 1241, 1270, 1300 };

          static int condEnd[] = { 1266, 1295, 1325 };

          static int pfixExpr[] = { 0, -1, 1, -3, 2, -1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,1,1240,1325,3,3,&(condStart[0]),&(condEnd[0]),
                                7,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 1366, 1396, 1425, 1454 };

          static int condEnd[] = { 1391, 1421, 1450, 1479 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -3, 3, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,2,1365,1479,4,6,&(condStart[0]),&(condEnd[0]),
                                9,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 1520, 1550, 1579, 1609 };

          static int condEnd[] = { 1545, 1575, 1604, 1634 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -3, 3, -1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,3,1519,1634,4,10,&(condStart[0]),&(condEnd[0]),
                                10,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 1675, 1705, 1735, 1764, 1793 };

          static int condEnd[] = { 1700, 1730, 1760, 1789, 1818 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -3, 4, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,4,1674,1818,5,14,&(condStart[0]),&(condEnd[0]),
                                12,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 1859, 1889, 1919, 1949, 1978 };

          static int condEnd[] = { 1884, 1914, 1944, 1974, 2003 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -1, -3, 4,
            -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,5,1858,2003,5,19,&(condStart[0]),&(condEnd[0]),
                                13,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 2044, 2074, 2104, 2133, 2163, 2192, 2221 };

          static int condEnd[] = { 2069, 2099, 2129, 2158, 2188, 2217, 2246 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -3, 4, -1,
            -3, 5, -3, 6, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,6,2043,2246,7,24,&(condStart[0]),&(condEnd[0]),
                                17,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 2287, 2317, 2347, 2376, 2406, 2435, 2465 };

          static int condEnd[] = { 2312, 2342, 2372, 2401, 2431, 2460, 2490 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -3, 4, -1,
            -3, 5, -3, 6, -1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,7,2286,2490,7,31,&(condStart[0]),&(condEnd[0]),
                                18,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 2531, 2561, 2591, 2620, 2650, 2680, 2709 };

          static int condEnd[] = { 2556, 2586, 2616, 2645, 2675, 2705, 2734 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -3, 4, -1,
            -3, 5, -1, -3, 6, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,8,2530,2734,7,38,&(condStart[0]),&(condEnd[0]),
                                18,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 2775, 2805, 2835, 2864, 2894, 2924, 2954 };

          static int condEnd[] = { 2800, 2830, 2860, 2889, 2919, 2949, 2979 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -3, 4, -1,
            -3, 5, -1, -3, 6, -1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,9,2774,2979,7,45,&(condStart[0]),&(condEnd[0]),
                                19,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 3020, 3050, 3080, 3110, 3140, 3169, 3198 };

          static int condEnd[] = { 3045, 3075, 3105, 3135, 3165, 3194, 3223 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -1, -3, 4,
            -1, -3, 5, -3, 6, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,10,3019,3223,7,52,&(condStart[0]),&(condEnd
            [0]),18,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 3264, 3294, 3324, 3354, 3384, 3413, 3443 };

          static int condEnd[] = { 3289, 3319, 3349, 3379, 3409, 3438, 3468 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -1, -3, 4,
            -1, -3, 5, -3, 6, -1, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,11,3263,3468,7,59,&(condStart[0]),&(condEnd
            [0]),19,&(pfixExpr[0]));
        }

        {
          static int condStart[] = { 3509, 3539, 3569, 3599, 3629, 3659, 3688 };

          static int condEnd[] = { 3534, 3564, 3594, 3624, 3654, 3684, 3713 };

          static int pfixExpr[] = { 0, -1, 1, -1, -3, 2, -1, -3, 3, -1, -3, 4,
            -1, -3, 5, -1, -3, 6, -3 };

          _SFD_CV_INIT_EML_MCDC(0,1,12,3508,3713,7,66,&(condStart[0]),&(condEnd
            [0]),19,&(pfixExpr[0]));
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(5,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(6,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(7,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(8,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(9,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(10,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(11,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(12,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(13,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c4_sf_marshallOut,(MexInFcnForType)c4_sf_marshallIn);
        _SFD_SET_DATA_VALUE_PTR(0U, chartInstance->c4_PrevTorque);
        _SFD_SET_DATA_VALUE_PTR(1U, chartInstance->c4_MeasTorque);
        _SFD_SET_DATA_VALUE_PTR(2U, chartInstance->c4_MeasPitch);
        _SFD_SET_DATA_VALUE_PTR(3U, chartInstance->c4_ModeGain);
        _SFD_SET_DATA_VALUE_PTR(4U, chartInstance->c4_GenSpeed);
        _SFD_SET_DATA_VALUE_PTR(5U, chartInstance->c4_GenTorque);
        _SFD_SET_DATA_VALUE_PTR(6U, chartInstance->c4_RatedSpeed);
        _SFD_SET_DATA_VALUE_PTR(7U, chartInstance->c4_KillIntegrator);
        _SFD_SET_DATA_VALUE_PTR(8U, &chartInstance->c4_omega_A);
        _SFD_SET_DATA_VALUE_PTR(9U, &chartInstance->c4_omega_B);
        _SFD_SET_DATA_VALUE_PTR(10U, &chartInstance->c4_omega_C);
        _SFD_SET_DATA_VALUE_PTR(11U, &chartInstance->c4_Demanded_torque);
        _SFD_SET_DATA_VALUE_PTR(12U, chartInstance->c4_Mode);
        _SFD_SET_DATA_VALUE_PTR(13U, &chartInstance->c4_Pitch_fine);
      }
    } else {
      sf_debug_reset_current_state_configuration(sfGlobalDebugInstanceStruct,
        _NREL5MW_Baseline_loads_2014bMachineNumber_,chartInstance->chartNumber,
        chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization(void)
{
  return "XHq9Jk6xtbDdaRHG3gVA0E";
}

static void sf_opaque_initialize_c4_NREL5MW_Baseline_loads_2014b(void
  *chartInstanceVar)
{
  chart_debug_initialization(((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c4_NREL5MW_Baseline_loads_2014b
    ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*) chartInstanceVar);
  initialize_c4_NREL5MW_Baseline_loads_2014b
    ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c4_NREL5MW_Baseline_loads_2014b(void
  *chartInstanceVar)
{
  enable_c4_NREL5MW_Baseline_loads_2014b
    ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c4_NREL5MW_Baseline_loads_2014b(void
  *chartInstanceVar)
{
  disable_c4_NREL5MW_Baseline_loads_2014b
    ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c4_NREL5MW_Baseline_loads_2014b(void
  *chartInstanceVar)
{
  sf_gateway_c4_NREL5MW_Baseline_loads_2014b
    ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*) chartInstanceVar);
}

static const mxArray* sf_opaque_get_sim_state_c4_NREL5MW_Baseline_loads_2014b
  (SimStruct* S)
{
  ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
  ChartInfoStruct * chartInfo = (ChartInfoStruct *)(crtInfo->instanceInfo);
  return get_sim_state_c4_NREL5MW_Baseline_loads_2014b
    ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
}

static void sf_opaque_set_sim_state_c4_NREL5MW_Baseline_loads_2014b(SimStruct* S,
  const mxArray *st)
{
  ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
  ChartInfoStruct * chartInfo = (ChartInfoStruct *)(crtInfo->instanceInfo);
  set_sim_state_c4_NREL5MW_Baseline_loads_2014b
    ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*)chartInfo->chartInstance,
     st);
}

static void sf_opaque_terminate_c4_NREL5MW_Baseline_loads_2014b(void
  *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*)
                    chartInstanceVar)->S;
    ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_NREL5MW_Baseline_loads_2014b_optimization_info();
    }

    finalize_c4_NREL5MW_Baseline_loads_2014b
      ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*) chartInstanceVar);
    utFree(chartInstanceVar);
    if (crtInfo != NULL) {
      utFree(crtInfo);
    }

    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc4_NREL5MW_Baseline_loads_2014b
    ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*) chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c4_NREL5MW_Baseline_loads_2014b(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
    ChartInfoStruct * chartInfo = (ChartInfoStruct *)(crtInfo->instanceInfo);
    initialize_params_c4_NREL5MW_Baseline_loads_2014b
      ((SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct*)
       (chartInfo->chartInstance));
  }
}

static void mdlSetWorkWidths_c4_NREL5MW_Baseline_loads_2014b(SimStruct *S)
{
  /* Actual parameters from chart:
     Demanded_torque Pitch_fine omega_B omega_C
   */
  const char_T *rtParamNames[] = { "Demanded_torque", "Pitch_fine", "omega_B",
    "omega_C" };

  ssSetNumRunTimeParams(S,ssGetSFcnParamsCount(S));

  /* registration for Demanded_torque*/
  ssRegDlgParamAsRunTimeParam(S, 0, 0, rtParamNames[0], SS_DOUBLE);

  /* registration for Pitch_fine*/
  ssRegDlgParamAsRunTimeParam(S, 1, 1, rtParamNames[1], SS_DOUBLE);

  /* registration for omega_B*/
  ssRegDlgParamAsRunTimeParam(S, 2, 2, rtParamNames[2], SS_DOUBLE);

  /* registration for omega_C*/
  ssRegDlgParamAsRunTimeParam(S, 3, 3, rtParamNames[3], SS_DOUBLE);
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_NREL5MW_Baseline_loads_2014b_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(sf_get_instance_specialization(),infoStruct,4);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(sf_get_instance_specialization(),
                infoStruct,4,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop
      (sf_get_instance_specialization(),infoStruct,4,
       "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(sf_get_instance_specialization(),infoStruct,4);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 2, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 3, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 4, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,4,5);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,4,4);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=4; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 5; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,4);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(675434839U));
  ssSetChecksum1(S,(3189621325U));
  ssSetChecksum2(S,(1453750217U));
  ssSetChecksum3(S,(3256001967U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c4_NREL5MW_Baseline_loads_2014b(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Truth Table");
  }
}

static void mdlStart_c4_NREL5MW_Baseline_loads_2014b(SimStruct *S)
{
  SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *chartInstance;
  ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)utMalloc(sizeof
    (ChartRunTimeInfo));
  chartInstance = (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct *)utMalloc
    (sizeof(SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct));
  memset(chartInstance, 0, sizeof
         (SFc4_NREL5MW_Baseline_loads_2014bInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.enableChart =
    sf_opaque_enable_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.disableChart =
    sf_opaque_disable_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.mdlStart = mdlStart_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c4_NREL5MW_Baseline_loads_2014b;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->chartInfo.callAtomicSubchartUserFcn = NULL;
  chartInstance->chartInfo.callAtomicSubchartAutoFcn = NULL;
  chartInstance->chartInfo.debugInstance = sfGlobalDebugInstanceStruct;
  chartInstance->S = S;
  crtInfo->checksum = SF_RUNTIME_INFO_CHECKSUM;
  crtInfo->instanceInfo = (&(chartInstance->chartInfo));
  crtInfo->isJITEnabled = false;
  crtInfo->compiledInfo = NULL;
  ssSetUserData(S,(void *)(crtInfo));  /* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  init_simulink_io_address(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c4_NREL5MW_Baseline_loads_2014b_method_dispatcher(SimStruct *S, int_T
  method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c4_NREL5MW_Baseline_loads_2014b(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c4_NREL5MW_Baseline_loads_2014b(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c4_NREL5MW_Baseline_loads_2014b(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c4_NREL5MW_Baseline_loads_2014b_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
