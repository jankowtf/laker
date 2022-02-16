extract_class_attribute <- function(
    data,
    n = 1,
    prefix = character()
) {
    data %>%
        class() %>%
        `[`(n) %>%
        {
            if (length(prefix)) {
                stringr::str_remove(., prefix)
            } else {
                .
            }
        }
}
