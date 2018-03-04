stop_cluster <- function() {
    current_nodes <- nrow(showConnections())
    cluster_defined <- exists(".cl", envir = .GlobalEnv)

    if (!cluster_defined) {
        if (current_nodes != 0) {
            warning("Unknown cluster found. Use stopCluster to stop it.")
        } else {
            message("No cluster defined.")
        }
    } else {
        .cl <- get(".cl", envir=.GlobalEnv)
        stopCluster(.cl)
        rm(".cl", envir = .GlobalEnv)
        message("Cluster with ", current_nodes, " nodes stopped.")
    }
    invisible()
}

#' Setup cluster with desired number of cores.
#'
#' Setup a cluster, only if not already defined.
#'
#' @param nodes Number of nodes that are used in this cluster. If missing the number of codes is used.
#' @import parallel
#' @import doParallel
#' @import foreach
start_cluster <- function(nodes = NA) {
    current_nodes <- nrow(showConnections())
    cluster_defined <- exists(".cl", envir = .GlobalEnv)

    if (!cluster_defined && current_nodes != 0) {
        warning("Unknown cluster found. Use stopCluster to stop it.")
        return(invisible())
    }

    if (cluster_defined) {
        if (is.na(nodes) || nodes == current_nodes) {
            warning("Cluster with ", current_nodes, " nodes already defined.")
            return(invisible())
        } else {
            stop_cluster()
        }
    }

    if (is.na(nodes)) nodes <- detectCores()

    .cl <- makeCluster(nodes)
    registerDoParallel(.cl)
    assign(".cl", .cl, envir = .GlobalEnv)
    message("Cluster with ", nodes, " nodes created.")
    invisible()
}

current_cluster <- function() {
    current_nodes <- nrow(showConnections())
    cluster_defined <- exists(".cl", envir = .GlobalEnv)

    if (!cluster_defined && current_nodes != 0) {
        warning("Unknown cluster found. Use stopCluster to stop it.")
        return(invisible())
    }

    if (cluster_defined) {
        message("Cluster with ", current_nodes, " nodes found.")
    } else {
        message("No cluster defined.")
    }
    invisible()
}
