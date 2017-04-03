/* Include files */

#include "NREL5MW_Baseline_loads_IPC_1P_v2_2014b_sfun.h"
#include "NREL5MW_Baseline_loads_IPC_1P_v2_2014b_sfun_debug_macros.h"
#include "c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b.h"
#include "c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b.h"
#include "c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b.h"
#include "c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
uint32_T _NREL5MW_Baseline_loads_IPC_1P_v2_2014bMachineNumber_;

/* Function Declarations */

/* Function Definitions */
void NREL5MW_Baseline_loads_IPC_1P_v2_2014b_initializer(void)
{
}

void NREL5MW_Baseline_loads_IPC_1P_v2_2014b_terminator(void)
{
}

/* SFunction Glue Code */
unsigned int sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_method_dispatcher
  (SimStruct *simstructPtr, unsigned int chartFileNumber, const char* specsCksum,
   int_T method, void *data)
{
  if (chartFileNumber==1) {
    c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_method_dispatcher(simstructPtr,
      method, data);
    return 1;
  }

  if (chartFileNumber==2) {
    c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_method_dispatcher(simstructPtr,
      method, data);
    return 1;
  }

  if (chartFileNumber==3) {
    c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_method_dispatcher(simstructPtr,
      method, data);
    return 1;
  }

  if (chartFileNumber==4) {
    c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_method_dispatcher(simstructPtr,
      method, data);
    return 1;
  }

  return 0;
}

extern void sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_uses_exported_functions
  (int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[])
{
  plhs[0] = mxCreateLogicalScalar(0);
}

unsigned int sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_process_check_sum_call
  ( int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[20];
  if (nrhs<1 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the checksum */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"sf_get_check_sum"))
    return 0;
  plhs[0] = mxCreateDoubleMatrix( 1,4,mxREAL);
  if (nrhs>1 && mxIsChar(prhs[1])) {
    mxGetString(prhs[1], commandName,sizeof(commandName)/sizeof(char));
    commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
    if (!strcmp(commandName,"machine")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3973069266U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(540268396U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3721638553U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(718560223U);
    } else if (!strcmp(commandName,"exportedFcn")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0U);
    } else if (!strcmp(commandName,"makefile")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(2415824755U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(396014895U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3568733914U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(537362215U);
    } else if (nrhs==3 && !strcmp(commandName,"chart")) {
      unsigned int chartFileNumber;
      chartFileNumber = (unsigned int)mxGetScalar(prhs[2]);
      switch (chartFileNumber) {
       case 1:
        {
          extern void sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_check_sum
            (mxArray *plhs[]);
          sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_check_sum(plhs);
          break;
        }

       case 2:
        {
          extern void sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_check_sum
            (mxArray *plhs[]);
          sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_check_sum(plhs);
          break;
        }

       case 3:
        {
          extern void sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_check_sum
            (mxArray *plhs[]);
          sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_check_sum(plhs);
          break;
        }

       case 4:
        {
          extern void sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_check_sum
            (mxArray *plhs[]);
          sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_check_sum(plhs);
          break;
        }

       default:
        ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0.0);
      }
    } else if (!strcmp(commandName,"target")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3061339410U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1991824845U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3599338742U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2357874978U);
    } else {
      return 0;
    }
  } else {
    ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3292252917U);
    ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(2167331457U);
    ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3851681917U);
    ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1649218449U);
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_autoinheritance_info( int
  nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[32];
  char aiChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the autoinheritance_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_autoinheritance_info"))
    return 0;
  mxGetString(prhs[2], aiChksum,sizeof(aiChksum)/sizeof(char));
  aiChksum[(sizeof(aiChksum)/sizeof(char)-1)] = '\0';

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(aiChksum, "o6VbucFwII8w10gK9RmNvD") == 0) {
          extern mxArray
            *sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_autoinheritance_info
            (void);
          plhs[0] =
            sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_autoinheritance_info
            ();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 2:
      {
        if (strcmp(aiChksum, "o6VbucFwII8w10gK9RmNvD") == 0) {
          extern mxArray
            *sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_autoinheritance_info
            (void);
          plhs[0] =
            sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_autoinheritance_info
            ();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 3:
      {
        if (strcmp(aiChksum, "c6C4BcieakepycdJZXUfn") == 0) {
          extern mxArray
            *sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_autoinheritance_info
            (void);
          plhs[0] =
            sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_autoinheritance_info
            ();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 4:
      {
        if (strcmp(aiChksum, "gqddKpoupFVsyXzayQBF5F") == 0) {
          extern mxArray
            *sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_autoinheritance_info
            (void);
          plhs[0] =
            sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_autoinheritance_info
            ();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int
  sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info( int
  nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[64];
  if (nrhs<2 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the get_eml_resolved_functions_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_eml_resolved_functions_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        extern const mxArray
          *sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info
          (void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info
          ();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 2:
      {
        extern const mxArray
          *sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info
          (void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info
          ();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 3:
      {
        extern const mxArray
          *sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info
          (void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info
          ();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 4:
      {
        extern const mxArray
          *sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info
          (void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_eml_resolved_functions_info
          ();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info
  ( int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the third_party_uses_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_third_party_uses_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "XYDLMRr6Y8ehiBY8NWTUqC") == 0) {
          extern mxArray
            *sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info
            (void);
          plhs[0] =
            sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info();
          break;
        }
      }

     case 2:
      {
        if (strcmp(tpChksum, "XYDLMRr6Y8ehiBY8NWTUqC") == 0) {
          extern mxArray
            *sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info
            (void);
          plhs[0] =
            sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info();
          break;
        }
      }

     case 3:
      {
        if (strcmp(tpChksum, "KckI4s8UIEI8OVHICGhj7C") == 0) {
          extern mxArray
            *sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info
            (void);
          plhs[0] =
            sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info();
          break;
        }
      }

     case 4:
      {
        if (strcmp(tpChksum, "XHq9Jk6xtbDdaRHG3gVA0E") == 0) {
          extern mxArray
            *sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info
            (void);
          plhs[0] =
            sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_third_party_uses_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

unsigned int sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info( int
  nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the jit_fallback_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_jit_fallback_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "XYDLMRr6Y8ehiBY8NWTUqC") == 0) {
          extern mxArray
            *sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info(void);
          plhs[0] =
            sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info();
          break;
        }
      }

     case 2:
      {
        if (strcmp(tpChksum, "XYDLMRr6Y8ehiBY8NWTUqC") == 0) {
          extern mxArray
            *sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info(void);
          plhs[0] =
            sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info();
          break;
        }
      }

     case 3:
      {
        if (strcmp(tpChksum, "KckI4s8UIEI8OVHICGhj7C") == 0) {
          extern mxArray
            *sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info(void);
          plhs[0] =
            sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info();
          break;
        }
      }

     case 4:
      {
        if (strcmp(tpChksum, "XHq9Jk6xtbDdaRHG3gVA0E") == 0) {
          extern mxArray
            *sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info(void);
          plhs[0] =
            sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_jit_fallback_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

unsigned int sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
  ( int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the updateBuildInfo_args_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_updateBuildInfo_args_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "XYDLMRr6Y8ehiBY8NWTUqC") == 0) {
          extern mxArray
            *sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
            (void);
          plhs[0] =
            sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
            ();
          break;
        }
      }

     case 2:
      {
        if (strcmp(tpChksum, "XYDLMRr6Y8ehiBY8NWTUqC") == 0) {
          extern mxArray
            *sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
            (void);
          plhs[0] =
            sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
            ();
          break;
        }
      }

     case 3:
      {
        if (strcmp(tpChksum, "KckI4s8UIEI8OVHICGhj7C") == 0) {
          extern mxArray
            *sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
            (void);
          plhs[0] =
            sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
            ();
          break;
        }
      }

     case 4:
      {
        if (strcmp(tpChksum, "XHq9Jk6xtbDdaRHG3gVA0E") == 0) {
          extern mxArray
            *sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
            (void);
          plhs[0] =
            sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_updateBuildInfo_args_info
            ();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

void sf_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info( int nlhs,
  mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{
  unsigned int chartFileNumber = (unsigned int) mxGetScalar(prhs[0]);
  char tpChksum[64];
  mxGetString(prhs[1], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  switch (chartFileNumber) {
   case 1:
    {
      if (strcmp(tpChksum, "XYDLMRr6Y8ehiBY8NWTUqC") == 0) {
        extern mxArray
          *sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info
          (void);
        plhs[0] =
          sf_c1_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info();
        return;
      }
    }
    break;

   case 2:
    {
      if (strcmp(tpChksum, "XYDLMRr6Y8ehiBY8NWTUqC") == 0) {
        extern mxArray
          *sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info
          (void);
        plhs[0] =
          sf_c2_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info();
        return;
      }
    }
    break;

   case 3:
    {
      if (strcmp(tpChksum, "KckI4s8UIEI8OVHICGhj7C") == 0) {
        extern mxArray
          *sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info
          (void);
        plhs[0] =
          sf_c3_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info();
        return;
      }
    }
    break;

   case 4:
    {
      if (strcmp(tpChksum, "XHq9Jk6xtbDdaRHG3gVA0E") == 0) {
        extern mxArray
          *sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info
          (void);
        plhs[0] =
          sf_c4_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_get_post_codegen_info();
        return;
      }
    }
    break;

   default:
    break;
  }

  plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
}

void NREL5MW_Baseline_loads_IPC_1P_v2_2014b_debug_initialize(struct
  SfDebugInstanceStruct* debugInstance)
{
  _NREL5MW_Baseline_loads_IPC_1P_v2_2014bMachineNumber_ =
    sf_debug_initialize_machine(debugInstance,
    "NREL5MW_Baseline_loads_IPC_1P_v2_2014b","sfun",0,4,0,0,0);
  sf_debug_set_machine_event_thresholds(debugInstance,
    _NREL5MW_Baseline_loads_IPC_1P_v2_2014bMachineNumber_,0,0);
  sf_debug_set_machine_data_thresholds(debugInstance,
    _NREL5MW_Baseline_loads_IPC_1P_v2_2014bMachineNumber_,0);
}

void NREL5MW_Baseline_loads_IPC_1P_v2_2014b_register_exported_symbols(SimStruct*
  S)
{
}

static mxArray* sRtwOptimizationInfoStruct= NULL;
mxArray* load_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct==NULL) {
    sRtwOptimizationInfoStruct = sf_load_rtw_optimization_info(
      "NREL5MW_Baseline_loads_IPC_1P_v2_2014b",
      "NREL5MW_Baseline_loads_IPC_1P_v2_2014b");
    mexMakeArrayPersistent(sRtwOptimizationInfoStruct);
  }

  return(sRtwOptimizationInfoStruct);
}

void unload_NREL5MW_Baseline_loads_IPC_1P_v2_2014b_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct!=NULL) {
    mxDestroyArray(sRtwOptimizationInfoStruct);
    sRtwOptimizationInfoStruct = NULL;
  }
}
