window.onerror = (err, file, line) ->
    if gon.debug
        alert """
            The following error occured: #{err}
            In file: #{file}
            At line: #{line}
        """
    return true
