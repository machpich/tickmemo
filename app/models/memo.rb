    # t.string "body"             #メモ内容
    # t.string "memoable_type"    #関連モデル（ポリモーフィック)
    # t.integer "memoable_id"     #関連モデルID

class Memo < ApplicationRecord
  belongs_to :memoable, polymorphic: true
end
