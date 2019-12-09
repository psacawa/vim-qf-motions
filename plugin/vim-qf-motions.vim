" malutkie skrypcio dodające ruchy [d, ]d
" te ruchy przesuwają kursor do następnej/poprzedniej pozycji w liście lokacji
" przyjmuje liczbę v:count i probuję zawijać koniec dokumentu
" ale to niestaty na razie nie działa :(

nnoremap <silent> ]d :call <Sid>LocFind(1)<cr>
nnoremap <silent> [d :call <Sid>LocFind(-1)<cr>

function! <Sid>loc_lt(loc1, loc2)
  return a:loc1[1] < a:loc2[1] || (a:loc1[1] == a:loc2[1] && a:loc1[2] < a:loc2[2])
endfunction
function! <Sid>loc_find (count)
  let curspos = getcurpos()
  let winnr = winnr()
  let locs = getloclist(l:winnr)
  call map (l:locs, {idx, l-> [l['bufnr'],l['lnum'],l['col'],0]})
"   echo l:curspos
"   echo l:locs
  let pos= 0
  " pos będzie lokacja w liście bezpośredio po kursorze
  " lub ewentualnie w pozycji  kursora
  while pos < len (locs) && <Sid>loc_lt (locs[pos], curspos)
    let pos = pos + 1
  endwhile
  let equal = (locs[pos][2] == curspos[2] && locs[pos][2] == curspos[2])
  " echo l:pos l:equal l:locs[l:pos]
  if a:count > 0
    " nowa pozycja ma być na indeks pos+count
    " jeśli pos było na kursorze, popraw o jedno (l:equal)
    " -1 bo przeskoczyliśmy kursora
    let newind = (l:pos+a:count+l:equal-1) % len(locs)
  elseif  a:count <0
    " w odwrotnym kierunku
    let newind = (l:pos+a:count) % len(locs)
    " jeśli mod będzie ujemne, trzeba trochę ponaprawiać
    if newind < 0
      let newind = len (locs) - newind
    endif
  else
    return
  endif
  let newpos = l:locs[l:newind]
  " echo "newind " . string(l:newind)." newpos ".string(l:newpos)
  call setpos ('.', newpos)
endfunction
function! <Sid>LocFind (dir)
  " echo a:dir v:count1
  call <Sid>loc_find(a:dir * v:count1)
endfunction

