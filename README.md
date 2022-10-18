# Overview

In this project, I will explore the Nutrition, Physical Activity, and Obesity -- Behavioral Risk Factor Surveillance System dataset provided by the CDC (https://chronicdata.cdc.gov/Nutrition-Physical-Activity-and-Obesity/Nutrition-Physical-Activity-and-Obesity-Behavioral/hn4x-zwk7). This dataset contains responses to questions about diet and physical activity stratified by geographic and demographic information for adults in the US for the years 2011-2020. I am interested in analyzing the relationships between different demographics and obesity over time, as well as differences in how different groups experience obesity. I plan to explore questions like Were there any changes in who was overweight, had poor nutrition, infrequent exercise, or were the demographics consistent? Which groups are currently most afflicted? Does obesity happen at different times of life for different races or income levels? Do some groups struggle with nutrition, while others with exercise? Understanding the trends and demographics around obesity could help to guide future policies and provide more focused care. 

# Using This Repository
To build the image, run: 
```
docker build . -t 611-final
```

Then run the container using: 
```
docker run -v $(pwd):/home/rstudio/work  -p 8787:8787 -e PASSWORD=pwd -it 611-final
```
