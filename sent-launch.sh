PARSED_OPTIONS=$(getopt -n "$0"  -o h --long "help,task:,data:,vis:"  -- "$@")

if [ $# -eq 0 ];
then
  echo 'No arguments provided. Use --help option for more details.'
  exit 1
fi

eval set -- "$PARSED_OPTIONS"

while true;
do
  case "$1" in

    -h|--help)
     echo -e "usage $0 -h display help \n \
     --help display help \n \
     --task name of the folder containing the task \n \
     --data name of the data file (zip format; name without the .zip) \n \
     --vis use of visual features or not (bool)"
      shift
      exit 0;;

    --task)
      if [ -n "$2" ];
      then
        task_name=$2
      fi
      shift 2;;

    --data)
      if [ -n "$2" ];
      then
        data_name=$2
      fi
      shift 2;;


    --vis)
      if [ -n "$2" ];
      then
        vis=$2
      fi
      shift 2;;

    --)
      shift;
      break;;
  esac
done

# Data name
datafile_name=${data_name}.zip

### Move data files to the right folder in deepQuest ###
cd quest
mkdir -p examples/${task_name}
cd ..
cp ../${datafile_name} quest/examples/${task_name} # Change here for the data file path
#cp ../sentence_test.zip quest/examples/${task_name} # Example
cd quest/examples/${task_name}

# Unzip data files
unzip ${datafile_name}


# Move files out of the folder
mv ./${data_name}/* ./

# Return to deepQuest folder
cd ../../..


### Move shell and config files ###
if [ "${vis}" = true ]; then # Multimodal sentence-level QE biRNN models with visual features (EncSentVis)
  mv train-test-sentQEBiRNN-vis.sh ./quest
  mv config-sentQEBiRNN-vis.py ./configs
else # Baseline sentence-level biRNN model (EncSent)
  mv train-test-sentQEBiRNN.sh ./quest
  mv config-sentQEBiRNN.py ./configs
fi
