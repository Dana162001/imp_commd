import os
import argparse

def extract_info_from_filename(filename):
    parts = filename.split('_')
    if len(parts) > 1:
        return parts[0], f"{input_path}/{filename.split('_')[0]}"
    return None, None

def generate_csv_content(filename, path):
    # Extract the fastq_id from the filename
    fastq_id = filename.split('_')[0]
    
    # Modify the 'path' variable in the [libraries] section
    modified_path = '/'.join(path.split('/')[:-1]) + '/'
    
    content = f"[gene-expression]\nreference,/hpcwork/rwth1209/reference_genome/human_GRCh38_10x\nprobe-set,/work/rwth1209/software/cellranger-7.1.0/probe_sets/Chromium_Human_Transcriptome_Probe_Set_v1.0.1_GRCh38-2020-A.csv\nno-bam,true\n\n[libraries]\nfastq_id,fastqs,feature_types\n{fastq_id},{modified_path},Gene Expression"
    return content

def main(input_path):
    csv_folder = os.path.join(input_path, "csv")
    os.makedirs(csv_folder, exist_ok=True)
    
    processed_prefixes = set()

    for root, dirs, files in os.walk(input_path):
        for file in files:
            if file.endswith(".fastq.gz"):
                filename = file.split('_')[0]
                if filename in processed_prefixes:
                    continue
                
                processed_prefixes.add(filename)
                
                file_path = os.path.join(root, file)
                output_csv = os.path.join(csv_folder, f"{filename}.csv")
                fastq_id, fastq_path = extract_info_from_filename(file)
                
                if fastq_id and fastq_path:
                    csv_content = generate_csv_content(fastq_id, fastq_path)
                    
                    with open(output_csv, 'w') as f:
                        f.write(csv_content)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate CSV files from .fastq.gz files.")
    parser.add_argument("-i", "--input", required=True, help="Path to the .fastq.gz files")
    args = parser.parse_args()
    input_path = args.input
    main(input_path)
