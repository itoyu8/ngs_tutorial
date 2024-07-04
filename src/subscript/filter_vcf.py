# 結果を格納するファイル
import sys
def filter_vcf(input_file, output_file):
    result = []

    # ファイルを読み込んで各行を処理
    with open(input_file, 'r') as file:
        for line in file:
            line = line.strip()
            if line.startswith("#"):
                # ヘッダー行はそのまま出力
                result.append(line)
                continue
            parts = line.split("\t")
            # 最後のフィールドをコロンで分割し，カンマで区切られた場合の合計値を計算する
            genotype_info = parts[-1]
            depth_info = genotype_info.split(":")[-1]
            depths = list(map(int, depth_info.split(",")))
            total_depth = sum(depths)
            
            # リード深度が10以上の行のみを選択し，さらに両方の値が4以上の行のみを選択する
            if total_depth >= 10:
                if len(depths) == 2 and all(d >= 4 for d in depths):
                    result.append(line)

    # 結果をファイルへ書き込む
    with open(output_file, 'w') as file:
        for line in result:
            file.write(line + "\n")

# 入力ファイルと出力ファイルのパス
input_file = sys.argv[1]
output_file = sys.argv[2]

# 実行
filter_vcf(input_file, output_file)

