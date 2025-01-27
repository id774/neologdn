# distutils: language=c++
# -*- coding: utf-8 -*-

from __future__ import unicode_literals
import itertools
from sys import version_info
from libc.stdlib cimport malloc, free
from libcpp.unordered_map cimport unordered_map
from libcpp.unordered_set cimport unordered_set

VERSION = (0, 1, 1)
__version__ = '0.1.1'

ASCII = (
    ('ａ', 'a'), ('ｂ', 'b'), ('ｃ', 'c'), ('ｄ', 'd'), ('ｅ', 'e'),
    ('ｆ', 'f'), ('ｇ', 'g'), ('ｈ', 'h'), ('ｉ', 'i'), ('ｊ', 'j'),
    ('ｋ', 'k'), ('ｌ', 'l'), ('ｍ', 'm'), ('ｎ', 'n'), ('ｏ', 'o'),
    ('ｐ', 'p'), ('ｑ', 'q'), ('ｒ', 'r'), ('ｓ', 's'), ('ｔ', 't'),
    ('ｕ', 'u'), ('ｖ', 'v'), ('ｗ', 'w'), ('ｘ', 'x'), ('ｙ', 'y'),
    ('ｚ', 'z'),
    ('Ａ', 'A'), ('Ｂ', 'B'), ('Ｃ', 'C'), ('Ｄ', 'D'), ('Ｅ', 'E'),
    ('Ｆ', 'F'), ('Ｇ', 'G'), ('Ｈ', 'H'), ('Ｉ', 'I'), ('Ｊ', 'J'),
    ('Ｋ', 'K'), ('Ｌ', 'L'), ('Ｍ', 'M'), ('Ｎ', 'N'), ('Ｏ', 'O'),
    ('Ｐ', 'P'), ('Ｑ', 'Q'), ('Ｒ', 'R'), ('Ｓ', 'S'), ('Ｔ', 'T'),
    ('Ｕ', 'U'), ('Ｖ', 'V'), ('Ｗ', 'W'), ('Ｘ', 'X'), ('Ｙ', 'Y'),
    ('Ｚ', 'Z'),
    ('！', '!'), ('”', '"'), ('＃', '#'), ('＄', '$'), ('％', '%'),
    ('＆', '&'), ('’', '\''), ('（', '('), ('）', ')'), ('＊', '*'),
    ('＋', '+'), ('，', ','), ('−', '-'), ('．', '.'), ('／', '/'),
    ('：', ':'), ('；', ';'), ('＜', '<'), ('＝', '='), ('＞', '>'),
    ('？', '?'), ('＠', '@'), ('［', '['), ('¥', '\\'), ('］', ']'),
    ('＾', '^'), ('＿', '_'), ('‘', '`'), ('｛', '{'), ('｜', '|'),
    ('｝', '}')
)
KANA = (
    ('ｱ', 'ア'), ('ｲ', 'イ'), ('ｳ', 'ウ'), ('ｴ', 'エ'), ('ｵ', 'オ'),
    ('ｶ', 'カ'), ('ｷ', 'キ'), ('ｸ', 'ク'), ('ｹ', 'ケ'), ('ｺ', 'コ'),
    ('ｻ', 'サ'), ('ｼ', 'シ'), ('ｽ', 'ス'), ('ｾ', 'セ'), ('ｿ', 'ソ'),
    ('ﾀ', 'タ'), ('ﾁ', 'チ'), ('ﾂ', 'ツ'), ('ﾃ', 'テ'), ('ﾄ', 'ト'),
    ('ﾅ', 'ナ'), ('ﾆ', 'ニ'), ('ﾇ', 'ヌ'), ('ﾈ', 'ネ'), ('ﾉ', 'ノ'),
    ('ﾊ', 'ハ'), ('ﾋ', 'ヒ'), ('ﾌ', 'フ'), ('ﾍ', 'ヘ'), ('ﾎ', 'ホ'),
    ('ﾏ', 'マ'), ('ﾐ', 'ミ'), ('ﾑ', 'ム'), ('ﾒ', 'メ'), ('ﾓ', 'モ'),
    ('ﾔ', 'ヤ'), ('ﾕ', 'ユ'), ('ﾖ', 'ヨ'),
    ('ﾗ', 'ラ'), ('ﾘ', 'リ'), ('ﾙ', 'ル'), ('ﾚ', 'レ'), ('ﾛ', 'ロ'),
    ('ﾜ', 'ワ'), ('ｦ', 'ヲ'), ('ﾝ', 'ン'),
    ('ｧ', 'ァ'), ('ｨ', 'ィ'), ('ｩ', 'ゥ'), ('ｪ', 'ェ'), ('ｫ', 'ォ'),
    ('ｯ', 'ッ'), ('ｬ', 'ャ'), ('ｭ', 'ュ'), ('ｮ', 'ョ'),
    ('｡', '。'), ('､', '、'), ('･', '・'), ('ﾞ', '゛'), ('ﾟ', '゜'),
    ('｢', '「'), ('｣', '」'), ('ｰ', 'ー')
)
DIGIT = (
    ('０', '0'), ('１', '1'), ('２', '2'), ('３', '3'), ('４', '4'),
    ('５', '5'), ('６', '6'), ('７', '7'), ('８', '8'), ('９', '9')
)
KANA_TEN = (
    ('カ', 'ガ'), ('キ', 'ギ'), ('ク', 'グ'), ('ケ', 'ゲ'), ('コ', 'ゴ'),
    ('サ', 'ザ'), ('シ', 'ジ'), ('ス', 'ズ'), ('セ', 'ゼ'), ('ソ', 'ゾ'),
    ('タ', 'ダ'), ('チ', 'ヂ'), ('ツ', 'ヅ'), ('テ', 'デ'), ('ト', 'ド'),
    ('ハ', 'バ'), ('ヒ', 'ビ'), ('フ', 'ブ'), ('ヘ', 'ベ'), ('ホ', 'ボ'),
    ('ウ', 'ヴ')
)
KANA_MARU = (
    ('ハ', 'パ'), ('ヒ', 'ピ'), ('フ', 'プ'), ('ヘ', 'ペ'), ('ホ', 'ポ')
)

HIPHENS = ('˗', '֊', '‐', '‑', '‒', '–', '⁃', '⁻', '₋', '−')
CHOONPUS = ('﹣', '－', 'ｰ', '—', '―', '─', '━', 'ー')
TILDES = ('~', '∼', '∾', '〜', '〰', '～')

SPACE = (' ', '　')

cdef unordered_map[Py_UNICODE, Py_UNICODE] conversion_map, kana_ten_map, kana_maru_map
cdef unordered_set[Py_UNICODE] blocks, basic_latin

for (before, after) in (ASCII + DIGIT + KANA):
    conversion_map[before] = after

for (before, after) in KANA_TEN:
    kana_ten_map[before] = after

for (before, after) in KANA_MARU:
    kana_maru_map[before] = after

char_codes = itertools.chain(
    range(19968, 40960),  # CJK UNIFIED IDEOGRAPHS
    range(12352, 12448),  # HIRAGANA
    range(12448, 12544),  # KATAKANA
    range(12289, 12352),  # CJK SYMBOLS AND PUNCTUATION
    range(65280, 65520)   # HALFWIDTH AND FULLWIDTH FORMS
)
if version_info >= (3, 0):
    chr_func = chr
else:
    chr_func = locals()['__builtins__'].unichr
for c in map(chr_func, char_codes):
    blocks.insert(c)

for c in map(chr_func, range(128)):
    basic_latin.insert(c)

del ASCII, KANA, DIGIT, KANA_TEN, KANA_MARU, char_codes, version_info, chr_func


cpdef unicode normalize(unicode text):
    cdef Py_UNICODE *buf = <Py_UNICODE *>malloc(sizeof(Py_UNICODE) * (len(text) + 1))

    cdef Py_UNICODE c, prev = '\0'
    cdef int pos = 0
    cdef bint lattin_space = False

    for c in text:
        if c in SPACE:
            c = ' '
            if prev == ' ' or blocks.count(prev):
                continue
            elif prev != '*' and pos > 0 and basic_latin.count(prev):
                lattin_space = True
                buf[pos] = c
            else:
                pos -= 1
        else:
            if c in HIPHENS:
                if prev == '-':
                    continue
                else:
                    buf[pos] = c = '-'
            elif c in CHOONPUS:
                if prev == 'ー':
                    continue
                else:
                    buf[pos] = c = 'ー'
            elif c in TILDES:
                continue
            else:
                if c == 'ﾞ':
                    pos -= 1
                    c = kana_ten_map[prev]
                elif c == 'ﾟ':
                    pos -= 1
                    c = kana_maru_map[prev]
                elif conversion_map.count(c):
                    c = conversion_map[c]
                if lattin_space and blocks.count(c):
                    pos -= 1
                lattin_space = False
                buf[pos] = c
        prev = c
        pos += 1

    if buf[pos-1] == ' ':
        pos -= 1
    buf[pos] = '\0'

    cdef unicode ret = buf
    free(buf)
    return ret
