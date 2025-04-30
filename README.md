# README

## Overview
This project involves the iterative adjustment of spike detections in neural data recordings. The main pipeline script processes spiking data from various recordings, applies thresholds, and combines the results. The detection algorithm script tests the spike detection algorithm and saves the results. The goal is to analyze neural activity by detecting spikes, applying non-negative matrix factorization (NMF), and visualizing the results.

## Main Components
- **Main Pipeline Script**: Iteratively processes spiking data, applies thresholds, and combines results.
- **Detection Algorithm Script**: Tests the spike detection algorithm and saves the results.
- **NMF Analysis**: Applies NMF to the spike matrix to identify neural patterns.
- **Visualization**: Generates and saves various plots to visualize the results.

## Tree of Code
- **main_pipeline.m**
  - **testDetectionAlgo06102024.m**
    - **detection_algorithm**
    - **gettingSpikeTimes3**
    - **spikeTimes2Logical**
    - **run_nnmf**
      - **ksGaussian**
      - **seqNMF**
        - **parse_seqNMF_params**
        - **reconstruct**
        - **shiftFactors**
        - **SimpleWHPlot**
        - **computeLoadingPercentPower**
    - **mapHtoNerveGroups**
    - **plotAllNeuronsStemSortedwSaveWOAttenuatedNeurons**
    - **plotAllNeuronsStemSortedwSave**
      - **plotproductWHwSave**
    - **labelNeuronsNNMFwSave**
      - **readdet_var**
      - **alignKernels** (nested function)
    - **extractBumps**
    - **plotIsolatedBumpswSave**
    - **plotNNProBumpswSave**
      - **padWithAdjacentValues** (nested function)
    - **plotNewNormBumps**
    - **plotNNAvgBumpswSave**
      - **padWithNaNs** (nested function)

## Code Structure and Functionality

### Main Pipeline Script
- **main_pipeline.m**: The primary script that orchestrates the entire process.
  - **Defines the main directory and gets subfolders**: Specifies the main directory containing subfolders with data.
  - **Defines lists of dates**: Lists of dates for different categories of data.
  - **Initializes global storage for combined data**: Variables to store combined results.
  - **Checks each subfolder for the file and processes it**: Loops through each subfolder and processes files using testDetectionAlgo06102024.
  - **Displays combined results**: Prints the combined data for verification.

### Detection Algorithm Script
- **testDetectionAlgo06102024.m**: Tests the spike detection algorithm and saves the results.
  - **Defines constant parameters for spike detection**: Parameters used for the spike detection algorithm.
  - **Loads and preprocesses data**: Loads data from the specified file and preprocesses it for analysis.
  - **Filters and processes channels**: Identifies channels to be analyzed and removes attenuated neurons if necessary.
  - **Spike detection and storage**: Loops through each channel, applies the detection algorithm, and stores the results.
  - **Nerve times and spike matrix**: Extracts spike times for specific nerves and converts them to a logical matrix.
  - **Non-negative matrix factorization (NMF)**: Applies NMF to the spike matrix and saves the results.
  - **Plotting and saving results**: Generates and saves various plots to visualize the results.

### Functions
#### Detection Algorithm Functions
- **detection_algorithm**: Detects spikes in the data using specified parameters.
- **gettingSpikeTimes3**: Extracts spike times from the data.
- **spikeTimes2Logical**: Converts spike times to a logical matrix.

#### NMF Functions
- **run_nnmf**: Runs non-negative matrix factorization on the spike matrix.
- **mapHtoNerveGroups**: Maps the NMF results to nerve groups.

#### Visualization Functions
- **plotAllNeuronsStemSortedwSave**: Plots and saves sorted neuron data.
- **labelNeuronsNNMFwSave**: Labels neurons and saves the results.
- **extractBumps**: Isolates BMPs from the data.
- **plotIsolatedBumpswSave**: Plots isolated BMPs and saves the results.
- **plotNNProBumpswSave**: Plots NN protraction bumps and saves the results.
- **plotNewNormBumps**: Plots new normalized BMPs.
- **plotNNAvgBumpswSave**: Plots the average of normalized BMPs.

#### Additional Functions
- **ksGaussian**: Applies Gaussian convolution to spike data.
- **seqNMF**: Applies sequence non-negative matrix factorization.
- **plotproductWHwSave**: Plots the product of matrices W and H as a heatmap.
- **readdet_var**: Reads kernel coordinates from the .det variable.

#### Nested Functions
- **reconstruct**: Reconstructs the data from W and H.
- **shiftFactors**: Shifts factors by the center of mass.
- **SimpleWHPlot**: Plots seqNMF factors W and H.
- **computeLoadingPercentPower**: Computes the loading percent power.

## Function Dependencies

### Main Functions and Their Dependencies
- **run_nnmf**: Calls ksGaussian, seqNMF.
- **seqNMF**: Calls parse_seqNMF_params, reconstruct, shiftFactors, SimpleWHPlot, computeLoadingPercentPower.
- **plotAllNeuronsStemSortedwSave**: Calls plotproductWHwSave.
- **labelNeuronsNNMFwSave**: Calls readdet_var, alignKernels (nested function).
- **plotNNProBumpswSave**: Calls padWithAdjacentValues (nested function).
- **plotNNAvgBumpswSave**: Calls padWithNaNs (nested function).

### Additional Functions
- **ksGaussian**: No additional functions called.
- **reconstruct**: No additional functions called.
- **shiftFactors**: No additional functions called.
- **SimpleWHPlot**: Calls reconstruct.
- **computeLoadingPercentPower**: Calls reconstruct.
- **plotproductWHwSave**: No additional functions called.
- **readdet_var**: No additional functions called.

## Downloading and Using the Code
To download and use the code, follow these steps:
1. **Download the Repository**: Clone or download the repository containing the scripts and functions.
2. **Set Up the Environment**: Ensure you have MATLAB installed and set up the necessary paths.
3. **Run the Main Pipeline Script**: Execute main_pipeline.m to start the processing of spiking data.
4. **Understand the Functions**: Refer to the detailed descriptions of each function to understand their purpose and usage.
