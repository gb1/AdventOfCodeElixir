method solve.

  types: begin of state_type,
           facing type string,
           x      type string,
           y      type string,
         end of state_type.

  types: begin of position_type,
           x type string,
           y type string,
         end of position_type.

  data: state type state_type.
  data: visited type table of position_type.
  data: answered2 type boolean.
  data: position type position_type.
  data: no_moves type i.

  data(input) =
`R2, L1, R2, R1, R1, L3, R3, L5, L5, L2, L1, R4, R1, R3, L5, L5, R3, L4, L4,` &&
` R5, R4, R3, L1, L2, R5, R4, L2, R1, R4, R4, L2, L1, L1, R190, R3, L4, R52,` &&
` R5, R3, L5, R3, R2, R1, L5, L5, L4, R2, L3, R3, L1, L3, R5, L3, L4, R3, R77,` &&
` R3, L2, R189, R4, R2, L2, R2, L1, R5, R4, R4, R2, L2, L2, L5, L1, R1, R2, L3,` &&
` L4, L5, R1, L1, L2, L2, R2, L3, R3, L4, L1, L5, L4, L4, R3, R5, L2, R4, R5,` &&
` R3, L2, L2, L4, L2, R2, L5, L4, R3, R1, L2, R2, R4, L1, L4, L4, L2, R2, L4,` &&
` L1, L1, R4, L1, L3, L2, L2, L5, R5, R2, R5, L1, L5, R2, R4, R4, L2, R5, L5, R5,` &&
` R5, L4, R2, R1, R1, R3, L3, L3, L4, L3, L2, L2, L2, R2, L1, L3, R2, R5, R5, L4,` &&
` R3, L3, L4, R2, L5, R5`.

*    input = 'R1, R1, R1, R1, L1, L1, L1, L1'.

  split input at ', ' into table data(moves).


  state-facing = 'N'.
  state-x = 0.
  state-y = 0.


  loop at moves into data(move).

    data(direction) = move(1).

    position-x = state-x.
    position-y = state-y.

    data(tail) = strlen( move ) - 1.

    data(no_moves_str) = move+1(tail).

    no_moves = no_moves_str.

    do no_moves times.
      case move(1).
        when 'R'.

          case state-facing.
            when 'N'.
              position-x = position-x + 1.
            when 'S'.
              position-x = position-x - 1.
            when 'E'.
              position-y = position-y - 1.
            when 'W'.
              position-y = position-y + 1.
          endcase.
        when 'L'.
          case state-facing.
            when 'N'.
              position-x = position-x - 1.
            when 'S'.
              position-x = position-x + 1.
            when 'E'.
              position-y = position-y + 1.
            when 'W'.
              position-y = position-y - 1.
          endcase.
      endcase.

      read table visited with key x = position-x y = position-y transporting no fields.
      if sy-subrc = 0 and answered2 = abap_false.
        data(answer2) = abs( position-x ) + abs( position-y ).
        write: 'answer 2: ' && answer2.
        answered2 = abap_true.
      endif.

      append position to visited.

    enddo.

    case move(1).
      when 'R'.

        case state-facing.
          when 'N'.
            state-facing = 'E'.
          when 'S'.
            state-facing = 'W'.
          when 'E'.
            state-facing = 'S'.
          when 'W'.
            state-facing = 'N'.
        endcase.
      when 'L'.
        case state-facing.
          when 'N'.
            state-facing = 'W'.
          when 'S'.
            state-facing = 'E'.
          when 'E'.
            state-facing = 'N'.
          when 'W'.
            state-facing = 'S'.
        endcase.
    endcase.

    state-x = position-x.
    state-y = position-y.

  endloop.

  data(answer1) = abs( state-x ) + abs( state-y ).

  write: 'answer 1: ' && answer1.

endmethod.
