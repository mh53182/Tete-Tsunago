module ApplicationHelper

  # 投稿フォーム用の改行を含むプレースホルダを定義
  def placeholder_text
    <<-"EOS".strip_heredoc
    今日のお子様の様子は？
    （350文字以内）
    EOS
  end

end
