# mammalToast
<i>Which are larger, mammals or toasters? Let's find out.</i>

## Justification
What fraction of mammals are charistmatic? Sure, there are already classification systems for megafauna, which comprise most of the charistmatic animals we think about. But when faced with someone's informal classification system overrated-if-larger-than-a-toaster, I asked the question: What fraction of mammals are larger than a toaster? So I decided to find out.

## Methods
I pooled trait data from four Ecology Data papers on mammal and placental mammal life history traits to estimate average mammal body mass [1]. I then merged this dataset with Burgin et al.'s 2018 paper on extant mammal species [2].

When multiple mass data points existed for adult individuals, I averaged them. To estimate body mass distributions across taxonomic groups, I assumed that morphological characteristics will be most similar within-genera, and estimated mass by averaging the masses of the next-lowest taxonomic group with mass data available (i.e., if species-level volume datapoints were not available, I set it to the average mass of individuals within the genus).

I converted from estimated body mass to body volume using density measurements aggregated in Brassey and Sellers, 2014 [3]. I took the average of the density measurements taken for the mammal species considered in that study.

I estimated average toaster volume by finding mean volume of the four products included in Amazon's "Compare Products" feature for the top non-promoted 2- and 4-slide toasters found using search term, "toaster."

Mammals were classified as larger or smaller than a toaster if their estimated body volume was greater or less than that of the average toaster volume.

## Results

90.6% of extant mammal species have body volumes larger than a toaster.

<figure><img src = "https://github.com/cjcampbell/mammalToast/blob/master/figs/volume_hist_simple.png"> </figure>
<figcaption>
<i>Figure 1: Estimated volumes of all extant mammals, grouped by order. Red vertical line shows average toaster volume.</i>
</figcaption>

## References

[1] Trait data:<br>
Ernest, 2003, <http://www.esapubs.org/archive/ecol/E084/093/Mammal_lifehistories_v2.txt><br>
PanTHERIA, <http://www.esapubs.org/archive/ecol/E090/184/PanTHERIA_1-0_WR05_Aug2008.txt><br>
PanTHERIA, <http://www.esapubs.org/archive/ecol/E090/184/PanTHERIA_1-0_WR93_Aug2008.txt><br>
Myhrvold et al., 2015, <http://www.esapubs.org/archive/ecol/E096/269/Data_Files/Amniote_Database_Aug_2015.csv><br>
Wilman et al,. 2014 <http://www.esapubs.org/archive/ecol/E095/178/MamFuncDat.txt><br>

[2] Burgin, C. J., Colella, J. P., Kahn, P. L., & Upham, N. S. (2018). How many species of mammals are there?. Journal of Mammalogy, 99(1), 1-14. <https://doi.org/10.1093/jmammal/gyx147>

[3] Brassey, C. A., & Sellers, W. I. (2014). Scaling of convex hull volume to body mass in modern primates, non-primate mammals and birds. PLoS One, 9(3), e91691. <https://doi.org/10.1371/journal.pone.0091691>
