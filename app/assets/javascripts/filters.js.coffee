psFilters = angular.module "psFilters", []

#############
## FILTERS ##
#############


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
		text.replace(/\n/g, '<br/>') if text?

psFilters.filter "truncate", ->
	(text, length=10, end='...') ->
		if length != 'false'
			# If the text length is less than 1.5x the truncation length, do nothing.
			if text and ( text.length <= (length * 1.5) )
				text
			else
				String(text).substring(0, length - end.length) + end

psFilters.filter 'currentUrl', ->
	(url=null) ->
		window.location.href

psFilters.filter 'originUrl', ->
	(url=null) ->
		window.location.origin

psFilters.filter 'urlEncode', ->
	(url) ->
		encodeURIComponent url

psFilters.filter 'urlSimplify', ->
	(url) ->
		if url?
			if (urls = url.split("//")).length > 1 then url = urls[1]
			if (urls = url.split("/")).length > 1 then url = urls[0]
			if (urls = url.split("?")).length > 1 then url = urls[0]
			if (urls = url.split("#")).length > 1 then url = urls[0]
		url

# TODO: attach this somwhere better
window.possessive = (text) ->
	if text
		if text[text.length - 1] == 's' then text + "'" else text + "'s"
	else
		''
psFilters.filter 'possessive', ->
	(text) ->
		window.possessive text

psFilters.filter 'fromNow', ->
	(date) ->
		moment(date).fromNow() if date?

psFilters.filter 'contains', ->
	(list, value) ->
		_.contains(list, value)

psFilters.filter 'pluck', ->
	(list, value) ->
		_.pluck(list, value)

psFilters.filter 'toHttps', ->
	(url) -> url?.replace(/^.*\/\//, 'https://')

