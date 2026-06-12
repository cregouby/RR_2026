# building latest hex-sticker assembly into images
library(hexsession)
library(here)
library(tidyverse)
source("R/make_tile.R") # modified make_tile to accept tibble and loacl images

# torch mlverse & friends
torch_tbl <- tibble(packages = c("luz", "torch", "torchdatasets", "hfhub", "safetensors", "scorcher",
                       "torchvision", "torchvisionlib", "innsight","tabnet", "brulee",
                       "tok", "minhub", "ETM", "torchaudio", "tft", "torchwavelets",
                       "torchgnn", "survdnn", "tinytorch"),
          local_images = c("https://torch.mlverse.org/css/images/hex/luz.png",
                           "https://torch.mlverse.org/css/images/hex/torch.png",
                           "images/torchdatasets.png",
                           "images/hfhub.png",
                           "images/safetensors.png",
                           "https://github.com/jtleek/scorcher/raw/main/man/figures/scorcher.png",

                           "https://torch.mlverse.org/css/images/hex/torchvision.png",
                           "images/torchvisionlib.png",
                           "https://bips-hb.github.io/innsight/reference/figures/logo.png",

                           "images/hex-tabnet(2).png",
                           "https://brulee.tidymodels.org/logo.png",


                           "images/tok.png",
                           "images/minhub.png",
                           "https://github.com/bnosac/ETM/raw/master/tools/example-visualisation.png",

                           "https://torch.mlverse.org/css/images/hex/torchaudio.png",
                           "images/tft.png",
                           "images/torchwavelets.png",
                           "images/torchgnn.png",
                           "images/survdnn.png",
                           "images/tinytorch.png"
                           ),
          local_urls = c("https://mlverse.github.io/luz/", "https://torch.mlverse.org/docs/",
                        "https://mlverse.github.io/torchdatasets/",  "https://mlverse.github.io/hfhub/",
                        "https://mlverse.github.io/safetensors/", "https://github.com/jtleek/scorcher",

                        "https://mlverse.github.io/torchvision/",
                        "https://mlverse.github.io/torchvisionlib/",
                        "https://bips-hb.github.io/innsight/",

                        "https://mlverse.github.io/tabnet/",
                        "https://brulee.tidymodels.org/",

                        "https://mlverse.github.io/tok/",
                        "https://mlverse.github.io/minhub/",
                        "https://github.com/bnosac/ETM",

                        "https://mlverse.github.io/torchaudio/",
                        "https://mlverse.github.io/tft/",
                        "https://github.com/mlverse/torchwavelets",
                        "https://josiahparry.github.io/torchgnn/",
                        "https://github.com/ielbadisy/survdnn",
                        "https://github.com/cornball-ai/tinytorch"
                        )
)
reticulated_tbl <- tibble(packages = c("tabpfn", "iltm", "tabicl", "tabdpt"),
          local_images = c("images/tabpfn.png",
                           "images/iltm.png",
                           "images/tabicl.png",
                           "images/tabdpt.png"
                           ),
          local_urls = c("https://github.com/tidymodels/tabpfn",
                        "https://github.com/frankiethull/iltm",
                        "https://github.com/frankiethull/tabicl",
                        "https://github.com/frankiethull/tabdpt"
                        )
)
make_tile(torch_tbl, output_dir = here())
snap_tile("images/tile_mlverse.png", screen_width = 600)
fs::file_move(here("temp_hexsession/_hexout.html"), here("temp_hexsession/torch.html"))

# reticulated
make_tile(reticulated_tbl, output_dir = here())
snap_tile("images/tile_reticulate.png")
fs::file_move(here("temp_hexsession/_hexout.html"), here("temp_hexsession/reticulate.html"))

#