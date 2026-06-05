# a modified version of hexsession::make_tile that
#  - accept local images as URLs
make_tile <- function (packages = NULL, local_images = NULL, local_urls = NULL, 
          dark_mode = FALSE, color_arrange = FALSE, highlight_mode = FALSE, 
          focus = NULL, output_dir = tempdir()) 
{
  temp_dir <- file.path(output_dir, "temp_hexsession")
  dir.create(temp_dir, showWarnings = FALSE)
  if (is.null(local_images)) {
    package_data <- get_pkg_data(packages)
    all_logopaths <- package_data$logopaths
    all_urls <- package_data$urls
    pkg_names <- package_data$packages
  }
  else {
    all_logopaths <- local_images
    all_urls <- local_urls
    pkg_names <- NULL
  }
  if (!is.null(focus) && !is.null(pkg_names)) {
    invalid_focus <- focus[!focus %in% pkg_names]
    if (length(invalid_focus) > 0) {
      warning("The following packages in 'focus' are not in the tile: ", 
              paste(invalid_focus, collapse = ", "))
      focus <- focus[focus %in% pkg_names]
    }
  }
  if (length(all_urls) < length(all_logopaths)) {
    all_urls <- c(all_urls, rep(NA, length(all_logopaths) - 
                                  length(all_urls)))
  }
  else if (length(all_urls) > length(all_logopaths)) {
    all_urls <- all_urls[1:length(all_logopaths)]
  }
  if (is.list(all_logopaths)) {
    all_logopaths <- unlist(all_logopaths, use.names = FALSE)
  }
  all_logopaths <- as.character(all_logopaths)
  valid_indices <- !is.na(all_logopaths) & nzchar(all_logopaths) & 
    (file.exists(all_logopaths) | httr2:::is_string_url(all_logopaths))
  all_logopaths <- all_logopaths[valid_indices]
  all_urls <- all_urls[valid_indices]
  if (!is.null(pkg_names)) {
    pkg_names <- pkg_names[valid_indices]
  }
  if (color_arrange && length(all_logopaths) > 0) {
    laborder <- col_arrange(all_logopaths)
    if (!is.null(laborder) && length(laborder) > 0) {
      order_match <- match(all_logopaths, laborder)
      valid_order_indices <- !is.na(order_match)
      all_logopaths <- all_logopaths[valid_order_indices]
      all_urls <- all_urls[valid_order_indices]
      if (!is.null(pkg_names)) {
        pkg_names <- pkg_names[valid_order_indices]
      }
      sorted_indices <- order(match(all_logopaths, laborder))
      all_logopaths <- all_logopaths[sorted_indices]
      all_urls <- all_urls[sorted_indices]
      if (!is.null(pkg_names)) {
        pkg_names <- pkg_names[sorted_indices]
      }
    }
    else {
      warning("Color arrangement failed. Proceeding without sorting.")
    }
  }
  if (length(all_logopaths) > 0) {
    temp_file <- file.path(temp_dir, "package_data.rds")
    saveRDS(list(logopaths = all_logopaths, urls = all_urls, 
                 packages = pkg_names), temp_file)
    js_file <- file.path(temp_dir, "hexsession.js")
    generate_hexsession_js(all_logopaths, all_urls, dark_mode, 
                           js_file, highlight_mode, pkg_names, focus)
    html_template_path <- system.file("templates", "_hexout_template.html", 
                                      package = "hexsession")
    html_template <- paste(readLines(html_template_path, 
                                     warn = FALSE), collapse = "\n")
    js_content <- paste(readLines(js_file, warn = FALSE), 
                        collapse = "\n")
    html_out_content <- sub("{{JS_CONTENT}}", js_content, 
                            html_template, fixed = TRUE)
    writeLines(html_out_content, file.path(temp_dir, "_hexout.html"))
    in_html_knitr <- isTRUE(getOption("knitr.in.progress")) && 
      requireNamespace("knitr", quietly = TRUE) && tryCatch(knitr::is_html_output(), 
                                                            error = function(e) FALSE)
    if (in_html_knitr) {
      html_content <- readLines(file.path(temp_dir, "_hexout.html"), 
                                warn = FALSE)
      body_content <- paste(html_content[grep("<body.*?>", 
                                              html_content):grep("</body>", html_content)], 
                            collapse = "\n")
      body_content <- gsub("</?body.*?>", "", body_content)
      div_content <- sprintf("<div class=\"hexsession-container\">%s</div>", 
                             body_content)
      return(htmltools::HTML(div_content))
    }
    else if (!isTRUE(getOption("knitr.in.progress"))) {
      html_out <- file.path(temp_dir, "_hexout.html")
      message("Tile saved to: ", html_out)
      viewer <- getOption("viewer")
      if (!is.null(viewer)) {
        viewer(html_out)
      }
      return(invisible(html_out))
    }
  }
  else {
    return(htmltools::HTML("<p>No valid package logos found to display.</p>"))
  }
}
