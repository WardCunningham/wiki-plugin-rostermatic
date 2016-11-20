
expand = (text)->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'
    .replace /\*(.+?)\*/g, '<i>$1</i>'

facts = (site, index) ->
  items = []
  items.push 'friend' if site.owner?.friend
  items.push 'google' if site.owner?.google
  items.push 'github' if site.owner?.github
  items.push 'twitter' if site.owner?.twitter
  items.push 'persona' if site.owner?.persona
  items.push 'moz' if site.persona
  items.push 'oid' if site.openid
  details = (word) -> "<span class=details>#{word}</span>"
  """<span style="float:right" data-index=#{index}>#{items.reverse().map(details).join ', '}</span>"""

report = (sites) ->
  result = []
  for site, index in sites
    if site.birth?
      d = site.file
      a = "#{d}:#{location.port}"
      p = "style='text-align: right; cell-padding-right: 6px;'"
      result.push """
        <tr class=row>
        <td>
          <img
            class=remote
            src="//#{a}/favicon.png"
            title=#{d}
            data-site=#{d}
            data-slug=welcome-visitors>
          <td class=domain>#{d}
          <td #{p}> #{facts site, index}
          <td #{p}> #{site.pages}
          <td #{p}> #{( (Date.now() - site.birth) / 1000 / 3600 / 24 / 31.5 ).toFixed(0) if site.birth}
      """
  "<table>#{result.join "\n"}</table>"
  
bright = (e) -> $(e.currentTarget).css 'background-color', '#f8f8f8'
normal = (e) -> $(e.currentTarget).css 'background-color', '#eee'
emit = ($item, item) ->
  $item.append """<p style="background-color:#eee;padding:15px;">"""
  $.getJSON '/plugin/rostermatic/sites', (data) ->
    $item.find('p').html report data.sites
    $item.find('.row').hover bright, normal
    $item.find('p .details').click (e) ->
      $parent = $(e.target).parent()
      site = data.sites[$parent.data('index')]
      provider = $(e.target).text()
      detail = switch provider
        when 'moz' then site.persona
        when 'oid' then site.openid
        else site.owner[provider]
      wiki.dialog "#{site.file} #{provider}", "#{JSON.stringify detail,null,'  '}"

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.rostermatic = {emit, bind} if window?
module.exports = {expand} if module?

