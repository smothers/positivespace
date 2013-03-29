#############
## FILTERS ##
#############

psFilters = angular.module "psFilters", []

psFilters.filter "range", ->
	(input, range) ->
		initial = parseInt(range[0])
		final = parseInt(range[1])
		i = initial
		while i < final
			input.push i
			i++
		input

psFilters.filter 'linebreaks', ->
	(text) ->
		text.replace(/\n/g, '<br/>') if text

psFilters.filter "truncate", ->
	(text, length=10, end='...') ->
		if length != 'false'
			# If the text length is less than 1.5x the truncation length, do nothing.
			if text and ( text.length <= (length * 1.5) )
				text
			else
				String(text).substring(0, length - end.length) + end

psFilters.filter 'urlEncode', ->
	(url) ->
		encodeURIComponent url

psFilters.filter 'urlSimplify', ->
	(url) ->
		if url? and (splitUrl = url.split("//")) and splitUrl.length > 1
			url = splitUrl[1]
		if url? and (splitUrl = url.split("/")) and splitUrl.length > 1
			url = splitUrl[0]
		url

