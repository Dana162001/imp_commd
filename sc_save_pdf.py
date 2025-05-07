import matplotlib.pyplot as plt
import matplotlib as mpl
import scanpy as sc

mpl.rcParams['pdf.fonttype'] = 42
mpl.rcParams['ps.fonttype'] = 42 
plt.rcParams['font.family'] = 'sans-serif'

sc.pl.umap(adata,
           color='cell_type',
           legend_loc='right margin',
           legend_fontsize='medium',
           size=30, #depends on the data
           legend_fontoutline=True,
           sort_order=False,
           palette=adata.uns["cell_type"], #optional
           title='snRNA-seq Human Heart',
           show=False)

plt.savefig("umap_test.pdf", dpi=600, format="pdf", bbox_inches='tight',transparent=False)
