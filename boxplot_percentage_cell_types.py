import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Create an empty DataFrame to store the percentages
percentages = pd.DataFrame()

# Group the data by 'patient_number' and then by 'cell_type'
grouped = adata.obs.groupby(['patient', 'cell_type']).size()

# Convert the series to a DataFrame and rename the column
grouped = grouped.reset_index(name='count')

# Calculate the total number of cells for each patient
total_counts = grouped.groupby('patient')['count'].transform('sum')

# Calculate the percentage of each cell type per patient
grouped['percentage'] = (grouped['count'] / total_counts) * 100

# Pivot the table to have one row per patient and one column per cell type with percentages as values
percentages = grouped.pivot(index='patient', columns='cell_type', values='percentage').fillna(0)

# Extract unique patient numbers and their corresponding disease group
patient_groups = adata.obs[['patient_group','patient']].drop_duplicates()

# Merge the disease group information into the percentages DataFrame
percentages = percentages.reset_index().merge(patient_groups, left_on='patient', right_index=True, how='left').set_index('patient')

percentages_reset = percentages.reset_index()

percentages_with_group = pd.merge(percentages_reset, patient_groups, on='patient', how='left')

# Optionally, if you want 'patient_number' to be the index again in the resulting DataFrame
percentages_with_group = percentages_with_group.set_index('patient')


# Melt the DataFrame to long format
melted_df = percentages_with_group.reset_index().melt(id_vars=['patient', 'patient_group'], var_name='cell_type', value_name='percentage')

# Create the box plot
plt.figure(figsize=(12, 6))  # Adjust the figure size as needed
sns.boxplot(x='cell_type', y='percentage', hue='patient_group', data=melted_df, palette='Set3', showfliers=False)

# Add individual points
sns.stripplot(x='cell_type', y='percentage', hue='patient_group', data=melted_df, color='black', size=4, jitter=True, dodge=True, marker='o', alpha=0.5, linewidth=0.5)

# Improve the plot
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0)  # Move the legend outside of the plot
plt.xticks(rotation=45, ha='right')  # Rotate the x-axis labels for better readability
plt.tight_layout()  # Adjust the layout to make room for the rotated x-axis labels

# Show the plot
plt.show()



# Melt the DataFrame to long format, if not already done
melted_df = percentages_with_group.reset_index().melt(id_vars=['patient', 'patient_group'], var_name='cell_type', value_name='percentage')

# Create a FacetGrid, each cell type gets its own plot with individual scales
g = sns.FacetGrid(melted_df, col='cell_type', col_wrap=4, sharex=False, sharey=False, height=5, aspect=1)

# Map the boxplot to each subplot
g.map(sns.boxplot, 'patient_group', 'percentage', palette='Set2', showfliers=False)

# Map the stripplot to each subplot to add individual points
g.map(sns.stripplot, 'patient_group', 'percentage', color='black', size=4, jitter=True, dodge=True, marker='o', alpha=0.5, linewidth=0.5)

# Iterate through axes to customize further
for ax in g.axes.flat:
    # Rotate the x-axis labels for better readability
    ax.set_xticklabels(ax.get_xticklabels(), rotation=45)
    # Optionally, set titles and adjust y-axis limits
    ax.set_title(ax.get_title().replace('cell_type = ', ''))

plt.tight_layout()  # Adjust the layout
plt.show()  # Show the plot
