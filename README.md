# imp_commd
Useful commands 

- Cellpose training
```
python -m cellpose\
 --train --use_gpu\
 --dir "/path/to/the/masks/"\
 --pretrained_model cyto2\
 --chan 0\ # 0=grayscale, 1=red, 2=green, 3=blue
 --chan2 0\
 --n_epochs 300\
 --learning_rate 0.1\
 --img_filter images --mask_filter masks
```
- Show all running jobs
```
squeue -u $USER -Su -o '%.10M %8i %20j %4t %5D %20R  %3C %7m %11l %11L'
```
- Download password protected dir from the link
```
wget -r --http-user=USERNAME --http-passwd='PASSWORD' --accept=gz link
wget -r --http-user=test --http-passwd='TEST' --accept=gz https://...
```
