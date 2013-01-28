window.onerror = (err, file, line) ->
    if gon.debug
        console.log """
            The following error occured: #{err}
            In file: #{file}
            At line: #{line}
        """
    return false

window.GramGoods = {}

GramGoods.error_message = """
    Sorry!
    Something went wrong...
    Please refresh the page and try again.
"""

GramGoods.header_offset = 56

GramGoods.capitalize = (string) -> string.charAt(0).toUpperCase() + string.slice(1)
