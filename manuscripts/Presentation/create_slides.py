import subprocess
import os

# Path to your Inkscape file
file_path = "initial_present_draft.svg"
output_dir = "exported_slides"
combined_pdf = "combined_presentation.pdf"

def get_layers(file_path):
    # Get layers and sublayers from the file
    result = subprocess.check_output(['inkscape', '--query-all', file_path]).decode().splitlines()
    layers = [line.split(',')[0] for line in result if 'layer' in line]
    return layers

def export_layers(file_path, layers):
    slide_counter = 1
    base_layers = [layer for layer in layers if '.' not in layer]  # Identify base layers
    exported_files = []
    for base_layer in base_layers:
        # Export base layer without sublayers
        base_output_file = os.path.join(output_dir, f"slide_{slide_counter:02}_base.pdf")
        subprocess.run(['inkscape', file_path, '--export-type=pdf', '--export-id=' + base_layer, '--export-id-only', '--export-filename=' + base_output_file])
        exported_files.append(base_output_file)
        slide_counter += 1
        
        # Find sublayers and export including sublayers
        sublayers = [sublayer for sublayer in layers if sublayer.startswith(base_layer + '.')]
        for sublayer in sublayers:
            output_file_with_sublayer = os.path.join(output_dir, f"slide_{slide_counter:02}_with_sublayer.pdf")
            # Export the base layer and the sublayer together
            subprocess.run(['inkscape', file_path, '--export-type=pdf', '--export-id=' + base_layer, '--export-id-only', '--export-id=' + sublayer, '--export-filename=' + output_file_with_sublayer])
            exported_files.append(output_file_with_sublayer)
            slide_counter += 1

    return exported_files

def combine_pdfs(exported_files, output_file):
    subprocess.run(['pdftk'] + exported_files + ['cat', 'output', output_file])

# Get all layers and sublayers
layers = get_layers(file_path)

# Export layers and sublayers
exported_files = export_layers(file_path, layers)

# Combine all exported PDFs into a single PDF
combine_pdfs(exported_files, combined_pdf)

print("Export and combination complete.")
