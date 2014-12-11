TEMPLATE = (intro, photo_url, twitter_name, twitter_id) ->
  """
<div class=\"hatena-module hatena-module-profile\">
  <div class=\"hatena-module-body\">
    <a href=\"http://hachibeechan.hateblo.jp/about\" class=\"profile-icon-link\">
      <img src=\"#{photo_url}\" alt=\"id:hachibeechan\" class=\"profile-icon\">
    </a>
    <span class=\"id\">
      <a href=\"http://hachibeechan.hateblo.jp/about\" class=\"hatena-id-link\"><span data-load-nickname=\"1\" data-user-name=\"hachibeechan\"><span class=\"user-name-nickname\">はっちん</span> <span class=\"user-name-paren\">(</span><span class=\"user-name-hatena-id\">id:hachibeechan</span><span class=\"user-name-paren\">)</span></span></a>
    </span>
    <div class=\"profile-description\">
      <p>#{intro}</p>
    </div>

    <div class=\"hatena-follow-button-box btn-subscribe\">
      <a href=\"#\" class=\"hatena-follow-button\">
        <span class=\"subscribing\">
          <span class=\"foreground\">購読中です</span>
          <span class=\"background\">読者をやめる</span>
        </span>
        <span class=\"unsubscribing\" data-track-name=\"profile-widget-subscribe-button\" data-track-once=\"\">
          <span class=\"foreground\">読者になる</span>
          <span class=\"background\">読者になる</span>
        </span>
      </a>
      <div class=\"subscription-count-box\" style=\"display: block;\">
        <i></i>
        <u></u>
        <span class=\"subscription-count\">0</span>
      </div>
    </div>
    <div class=\"twitter--follow__button--box\">
      <a class=\"btn twitter--follow__button\" title=\"Twitterで#{twitter_name} (@#{twitter_id})さんをフォローしましょう\" href=\"https://twitter.com/intent/follow?region=follow_link?screen_name=#{twitter_id}?tw_p=followbutton\">
        <span class=\"label\">@#{twitter_id}さんをフォロー</span>
      </a>
    </div>
  </div>
</div>
"""


app = new Vue({
  el: '#datas'
  data:
    introduction: ''
    twitter_name: ''
    twitter_id: ''
    photo_url: ''
    preview_data: ''
  methods:
    render_preview: () ->
      @preview_data = TEMPLATE @introduction, @photo_url, @twitter_name, @twitter_id
})

