(module $module.wasm
  (type (;0;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;1;) (func (param i32)))
  (type (;2;) (func (param i32 i32 i32) (result i32)))
  (type (;3;) (func (param i32 f64 i32 i32 i32 i32) (result i32)))
  (type (;4;) (func (param i32 i32)))
  (type (;5;) (func (param i32 i64 i32) (result i64)))
  (type (;6;) (func (param i32 i32) (result i32)))
  (type (;7;) (func))
  (type (;8;) (func (param i32) (result i32)))
  (type (;9;) (func (param i32 i64 i32 i32) (result i32)))
  (type (;10;) (func (param f64) (result f64)))
  (type (;11;) (func (param i32 f64) (result f64)))
  (type (;12;) (func (param i32) (result f64)))
  (type (;13;) (func (param f64 f64) (result f64)))
  (type (;14;) (func (param f64) (result i32)))
  (type (;15;) (func (param i64) (result i32)))
  (type (;16;) (func (param i64 i32) (result f64)))
  (type (;17;) (func (param f64 f64 i32) (result f64)))
  (type (;18;) (func (param f64 i64 i64) (result f64)))
  (type (;19;) (func (param f64)))
  (type (;20;) (func (result i32)))
  (type (;21;) (func (param f64 i32) (result f64)))
  (type (;22;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;23;) (func (param i32 i32 i32 i32 i32 i32 i32) (result i32)))
  (type (;24;) (func (param i32 i32 i32)))
  (type (;25;) (func (param i32 i32 i32 i32)))
  (type (;26;) (func (param i64 i32 i32) (result i32)))
  (type (;27;) (func (param i64 i32) (result i32)))
  (type (;28;) (func (param i32 i32 i32 i32 i32)))
  (type (;29;) (func (param f64) (result i64)))
  (type (;30;) (func (param i32 i64 i64 i32)))
  (type (;31;) (func (param i64 i64) (result f64)))
  (import "env" "exit" (func $exit (type 1)))
  (import "env" "jsSanitize" (func $jsSanitize (type 6)))
  (import "env" "_abort_js" (func $_abort_js (type 7)))
  (import "wasi_snapshot_preview1" "fd_close" (func $__wasi_fd_close (type 8)))
  (import "wasi_snapshot_preview1" "fd_write" (func $__wasi_fd_write (type 0)))
  (import "wasi_snapshot_preview1" "fd_seek" (func $__wasi_fd_seek (type 9)))
  (import "env" "emscripten_resize_heap" (func $emscripten_resize_heap (type 8)))
  (func $__wasm_call_ctors (type 7)
    call $emscripten_stack_init
    call $init_pthread_self)
  (func $init_stuff (type 1) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 1
    i32.const 16
    local.set 2
    local.get 1
    local.get 2
    i32.sub
    local.set 3
    local.get 3
    global.set $__stack_pointer
    local.get 3
    local.get 0
    i32.store offset=12
    local.get 3
    i32.load offset=12
    local.set 4
    i32.const 0
    local.set 5
    local.get 4
    local.get 5
    i32.store offset=12
    local.get 3
    i32.load offset=12
    local.set 6
    i32.const 10
    local.set 7
    local.get 6
    local.get 7
    i32.store offset=16
    local.get 3
    i32.load offset=12
    local.set 8
    i32.const 4
    local.set 9
    local.get 8
    local.get 9
    i32.add
    local.set 10
    i32.const 0
    local.set 11
    local.get 11
    i32.load16_u offset=65585 align=1
    local.set 12
    local.get 10
    local.get 12
    i32.store16 align=1
    local.get 11
    i32.load offset=65581 align=1
    local.set 13
    local.get 8
    local.get 13
    i32.store align=1
    local.get 3
    i32.load offset=12
    local.set 14
    local.get 14
    i32.load offset=16
    local.set 15
    i32.const 28
    local.set 16
    local.get 15
    local.get 16
    i32.mul
    local.set 17
    local.get 17
    call $emscripten_builtin_malloc
    local.set 18
    local.get 3
    i32.load offset=12
    local.set 19
    local.get 19
    local.get 18
    i32.store offset=8
    local.get 3
    i32.load offset=12
    local.set 20
    local.get 20
    i32.load offset=8
    local.set 21
    i32.const 0
    local.set 22
    local.get 21
    local.get 22
    i32.eq
    local.set 23
    i32.const 1
    local.set 24
    local.get 23
    local.get 24
    i32.and
    local.set 25
    block  ;; label = @1
      local.get 25
      i32.eqz
      br_if 0 (;@1;)
      i32.const 1
      local.set 26
      local.get 26
      call $exit
      unreachable
    end
    i32.const 16
    local.set 27
    local.get 3
    local.get 27
    i32.add
    local.set 28
    local.get 28
    global.set $__stack_pointer
    return)
  (func $initCacheTable (type 7)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    i32.const 1
    local.set 0
    i32.const 264
    local.set 1
    local.get 0
    local.get 1
    call $emscripten_builtin_calloc
    local.set 2
    i32.const 0
    local.set 3
    local.get 3
    local.get 2
    i32.store offset=75116
    i32.const 0
    local.set 4
    local.get 4
    i32.load offset=75116
    local.set 5
    i32.const 4
    local.set 6
    local.get 5
    local.get 6
    i32.add
    local.set 7
    i32.const 0
    local.set 8
    local.get 8
    i32.load offset=65649 align=1
    local.set 9
    local.get 7
    local.get 9
    i32.store align=1
    i32.const 0
    local.set 10
    local.get 10
    i32.load offset=75116
    local.set 11
    i32.const 0
    local.set 12
    local.get 11
    local.get 12
    i32.store
    return)
  (func $sanitize (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 3
    i32.const 32
    local.set 4
    local.get 3
    local.get 4
    i32.sub
    local.set 5
    local.get 5
    global.set $__stack_pointer
    local.get 5
    local.get 0
    i32.store offset=28
    local.get 5
    local.get 1
    i32.store offset=24
    local.get 5
    local.get 2
    i32.store offset=20
    local.get 5
    i32.load offset=24
    local.set 6
    i32.const 6
    local.set 7
    local.get 6
    local.get 7
    i32.mul
    local.set 8
    local.get 8
    call $emscripten_builtin_malloc
    local.set 9
    local.get 5
    local.get 9
    i32.store offset=16
    i32.const 0
    local.set 10
    local.get 5
    local.get 10
    i32.store offset=12
    i32.const 0
    local.set 11
    local.get 5
    local.get 11
    i32.store offset=8
    block  ;; label = @1
      loop  ;; label = @2
        local.get 5
        i32.load offset=8
        local.set 12
        local.get 5
        i32.load offset=24
        local.set 13
        local.get 12
        local.get 13
        i32.lt_u
        local.set 14
        i32.const 1
        local.set 15
        local.get 14
        local.get 15
        i32.and
        local.set 16
        local.get 16
        i32.eqz
        br_if 1 (;@1;)
        local.get 5
        i32.load offset=28
        local.set 17
        local.get 5
        i32.load offset=8
        local.set 18
        local.get 17
        local.get 18
        i32.add
        local.set 19
        local.get 19
        i32.load8_s
        local.set 20
        i32.const -34
        local.set 21
        local.get 20
        local.get 21
        i32.add
        local.set 22
        i32.const 28
        local.set 23
        local.get 22
        local.get 23
        i32.gt_u
        drop
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 22
                        br_table 4 (;@6;) 6 (;@4;) 6 (;@4;) 2 (;@8;) 3 (;@7;) 5 (;@5;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 6 (;@4;) 0 (;@10;) 6 (;@4;) 1 (;@9;) 6 (;@4;)
                      end
                      local.get 5
                      i32.load offset=16
                      local.set 24
                      local.get 5
                      i32.load offset=12
                      local.set 25
                      local.get 24
                      local.get 25
                      i32.add
                      local.set 26
                      i32.const 0
                      local.set 27
                      local.get 27
                      i32.load offset=65611 align=1
                      local.set 28
                      local.get 26
                      local.get 28
                      i32.store align=1
                      local.get 5
                      i32.load offset=12
                      local.set 29
                      i32.const 4
                      local.set 30
                      local.get 29
                      local.get 30
                      i32.add
                      local.set 31
                      local.get 5
                      local.get 31
                      i32.store offset=12
                      br 6 (;@3;)
                    end
                    local.get 5
                    i32.load offset=16
                    local.set 32
                    local.get 5
                    i32.load offset=12
                    local.set 33
                    local.get 32
                    local.get 33
                    i32.add
                    local.set 34
                    i32.const 0
                    local.set 35
                    local.get 35
                    i32.load offset=65616 align=1
                    local.set 36
                    local.get 34
                    local.get 36
                    i32.store align=1
                    local.get 5
                    i32.load offset=12
                    local.set 37
                    i32.const 4
                    local.set 38
                    local.get 37
                    local.get 38
                    i32.add
                    local.set 39
                    local.get 5
                    local.get 39
                    i32.store offset=12
                    br 5 (;@3;)
                  end
                  local.get 5
                  i32.load offset=16
                  local.set 40
                  local.get 5
                  i32.load offset=12
                  local.set 41
                  local.get 40
                  local.get 41
                  i32.add
                  local.set 42
                  i32.const 4
                  local.set 43
                  local.get 42
                  local.get 43
                  i32.add
                  local.set 44
                  i32.const 0
                  local.set 45
                  local.get 45
                  i32.load8_u offset=65631
                  local.set 46
                  local.get 44
                  local.get 46
                  i32.store8
                  local.get 45
                  i32.load offset=65627 align=1
                  local.set 47
                  local.get 42
                  local.get 47
                  i32.store align=1
                  local.get 5
                  i32.load offset=12
                  local.set 48
                  i32.const 5
                  local.set 49
                  local.get 48
                  local.get 49
                  i32.add
                  local.set 50
                  local.get 5
                  local.get 50
                  i32.store offset=12
                  br 4 (;@3;)
                end
                local.get 5
                i32.load offset=16
                local.set 51
                local.get 5
                i32.load offset=12
                local.set 52
                local.get 51
                local.get 52
                i32.add
                local.set 53
                i32.const 4
                local.set 54
                local.get 53
                local.get 54
                i32.add
                local.set 55
                i32.const 0
                local.set 56
                local.get 56
                i32.load8_u offset=65625
                local.set 57
                local.get 55
                local.get 57
                i32.store8
                local.get 56
                i32.load offset=65621 align=1
                local.set 58
                local.get 53
                local.get 58
                i32.store align=1
                local.get 5
                i32.load offset=12
                local.set 59
                i32.const 5
                local.set 60
                local.get 59
                local.get 60
                i32.add
                local.set 61
                local.get 5
                local.get 61
                i32.store offset=12
                br 3 (;@3;)
              end
              local.get 5
              i32.load offset=16
              local.set 62
              local.get 5
              i32.load offset=12
              local.set 63
              local.get 62
              local.get 63
              i32.add
              local.set 64
              i32.const 4
              local.set 65
              local.get 64
              local.get 65
              i32.add
              local.set 66
              i32.const 0
              local.set 67
              local.get 67
              i32.load16_u offset=65608 align=1
              local.set 68
              local.get 66
              local.get 68
              i32.store16 align=1
              local.get 67
              i32.load offset=65604 align=1
              local.set 69
              local.get 64
              local.get 69
              i32.store align=1
              local.get 5
              i32.load offset=12
              local.set 70
              i32.const 6
              local.set 71
              local.get 70
              local.get 71
              i32.add
              local.set 72
              local.get 5
              local.get 72
              i32.store offset=12
              br 2 (;@3;)
            end
            local.get 5
            i32.load offset=16
            local.set 73
            local.get 5
            i32.load offset=12
            local.set 74
            local.get 73
            local.get 74
            i32.add
            local.set 75
            i32.const 4
            local.set 76
            local.get 75
            local.get 76
            i32.add
            local.set 77
            i32.const 0
            local.set 78
            local.get 78
            i32.load16_u offset=65637 align=1
            local.set 79
            local.get 77
            local.get 79
            i32.store16 align=1
            local.get 78
            i32.load offset=65633 align=1
            local.set 80
            local.get 75
            local.get 80
            i32.store align=1
            local.get 5
            i32.load offset=12
            local.set 81
            i32.const 6
            local.set 82
            local.get 81
            local.get 82
            i32.add
            local.set 83
            local.get 5
            local.get 83
            i32.store offset=12
            br 1 (;@3;)
          end
          local.get 5
          i32.load offset=28
          local.set 84
          local.get 5
          i32.load offset=8
          local.set 85
          local.get 84
          local.get 85
          i32.add
          local.set 86
          local.get 86
          i32.load8_u
          local.set 87
          i32.const 24
          local.set 88
          local.get 87
          local.get 88
          i32.shl
          local.set 89
          local.get 89
          local.get 88
          i32.shr_s
          local.set 90
          i32.const 32
          local.set 91
          local.get 90
          local.get 91
          i32.ge_s
          local.set 92
          i32.const 1
          local.set 93
          local.get 92
          local.get 93
          i32.and
          local.set 94
          block  ;; label = @4
            local.get 94
            i32.eqz
            br_if 0 (;@4;)
            local.get 5
            i32.load offset=28
            local.set 95
            local.get 5
            i32.load offset=8
            local.set 96
            local.get 95
            local.get 96
            i32.add
            local.set 97
            local.get 97
            i32.load8_u
            local.set 98
            i32.const 24
            local.set 99
            local.get 98
            local.get 99
            i32.shl
            local.set 100
            local.get 100
            local.get 99
            i32.shr_s
            local.set 101
            i32.const 127
            local.set 102
            local.get 101
            local.get 102
            i32.le_s
            local.set 103
            i32.const 1
            local.set 104
            local.get 103
            local.get 104
            i32.and
            local.set 105
            local.get 105
            i32.eqz
            br_if 0 (;@4;)
            local.get 5
            i32.load offset=28
            local.set 106
            local.get 5
            i32.load offset=8
            local.set 107
            local.get 106
            local.get 107
            i32.add
            local.set 108
            local.get 108
            i32.load8_u
            local.set 109
            local.get 5
            i32.load offset=16
            local.set 110
            local.get 5
            i32.load offset=12
            local.set 111
            i32.const 1
            local.set 112
            local.get 111
            local.get 112
            i32.add
            local.set 113
            local.get 5
            local.get 113
            i32.store offset=12
            local.get 110
            local.get 111
            i32.add
            local.set 114
            local.get 114
            local.get 109
            i32.store8
          end
        end
        local.get 5
        i32.load offset=8
        local.set 115
        i32.const 1
        local.set 116
        local.get 115
        local.get 116
        i32.add
        local.set 117
        local.get 5
        local.get 117
        i32.store offset=8
        br 0 (;@2;)
      end
    end
    local.get 5
    i32.load offset=12
    local.set 118
    local.get 5
    i32.load offset=20
    local.set 119
    local.get 119
    local.get 118
    i32.store
    local.get 5
    i32.load offset=16
    local.set 120
    i32.const 32
    local.set 121
    local.get 5
    local.get 121
    i32.add
    local.set 122
    local.get 122
    global.set $__stack_pointer
    local.get 120
    return)
  (func $toSafeHTML (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 32
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=28
    local.get 4
    local.get 1
    i32.store offset=24
    local.get 4
    i32.load offset=24
    local.set 5
    i32.const 100
    local.set 6
    local.get 5
    local.get 6
    i32.add
    local.set 7
    local.get 4
    local.get 7
    i32.store offset=20
    local.get 4
    i32.load offset=20
    local.set 8
    local.get 8
    call $emscripten_builtin_malloc
    local.set 9
    local.get 4
    local.get 9
    i32.store offset=16
    local.get 4
    i32.load offset=16
    local.set 10
    local.get 4
    i32.load offset=20
    local.set 11
    local.get 4
    i32.load offset=24
    local.set 12
    local.get 4
    i32.load offset=28
    local.set 13
    local.get 4
    local.get 13
    i32.store offset=4
    local.get 4
    local.get 12
    i32.store
    i32.const 65588
    local.set 14
    local.get 10
    local.get 11
    local.get 14
    local.get 4
    call $snprintf
    drop
    local.get 4
    i32.load offset=16
    local.set 15
    i32.const 32
    local.set 16
    local.get 4
    local.get 16
    i32.add
    local.set 17
    local.get 17
    global.set $__stack_pointer
    local.get 15
    return)
  (func $sanitizeWithJs (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 3
    i32.const 32
    local.set 4
    local.get 3
    local.get 4
    i32.sub
    local.set 5
    local.get 5
    global.set $__stack_pointer
    local.get 5
    local.get 0
    i32.store offset=28
    local.get 5
    local.get 1
    i32.store offset=24
    local.get 5
    local.get 2
    i32.store offset=20
    local.get 5
    i32.load offset=24
    local.set 6
    i32.const 1
    local.set 7
    local.get 6
    local.get 7
    i32.add
    local.set 8
    local.get 8
    call $emscripten_builtin_malloc
    local.set 9
    local.get 5
    local.get 9
    i32.store offset=16
    local.get 5
    i32.load offset=24
    local.set 10
    i32.const 3
    local.set 11
    local.get 10
    local.get 11
    i32.mul
    local.set 12
    local.get 12
    call $emscripten_builtin_malloc
    local.set 13
    local.get 5
    local.get 13
    i32.store offset=12
    local.get 5
    i32.load offset=16
    local.set 14
    i32.const 0
    local.set 15
    local.get 14
    local.get 15
    i32.ne
    local.set 16
    i32.const 1
    local.set 17
    local.get 16
    local.get 17
    i32.and
    local.set 18
    block  ;; label = @1
      block  ;; label = @2
        local.get 18
        i32.eqz
        br_if 0 (;@2;)
        local.get 5
        i32.load offset=12
        local.set 19
        i32.const 0
        local.set 20
        local.get 19
        local.get 20
        i32.ne
        local.set 21
        i32.const 1
        local.set 22
        local.get 21
        local.get 22
        i32.and
        local.set 23
        local.get 23
        br_if 1 (;@1;)
      end
      local.get 5
      i32.load offset=16
      local.set 24
      local.get 24
      call $emscripten_builtin_free
      local.get 5
      i32.load offset=12
      local.set 25
      local.get 25
      call $emscripten_builtin_free
      i32.const 1
      local.set 26
      local.get 26
      call $exit
      unreachable
    end
    local.get 5
    i32.load offset=16
    local.set 27
    local.get 5
    i32.load offset=28
    local.set 28
    local.get 5
    i32.load offset=24
    local.set 29
    local.get 27
    local.get 28
    local.get 29
    call $strncpy
    drop
    local.get 5
    i32.load offset=16
    local.set 30
    local.get 5
    i32.load offset=24
    local.set 31
    local.get 30
    local.get 31
    i32.add
    local.set 32
    i32.const 0
    local.set 33
    local.get 32
    local.get 33
    i32.store8
    local.get 5
    i32.load offset=16
    local.set 34
    local.get 5
    i32.load offset=12
    local.set 35
    local.get 34
    local.get 35
    call $jsSanitize
    local.set 36
    local.get 5
    local.get 36
    i32.store offset=8
    local.get 5
    i32.load offset=8
    local.set 37
    local.get 5
    i32.load offset=20
    local.set 38
    local.get 38
    local.get 37
    i32.store
    local.get 5
    i32.load offset=20
    local.set 39
    local.get 39
    i32.load
    local.set 40
    i32.const 1
    local.set 41
    local.get 40
    local.get 41
    i32.add
    local.set 42
    local.get 42
    call $emscripten_builtin_malloc
    local.set 43
    local.get 5
    local.get 43
    i32.store offset=4
    local.get 5
    i32.load offset=8
    local.set 44
    i32.const 0
    local.set 45
    local.get 44
    local.get 45
    i32.ge_s
    local.set 46
    i32.const 1
    local.set 47
    local.get 46
    local.get 47
    i32.and
    local.set 48
    block  ;; label = @1
      block  ;; label = @2
        local.get 48
        i32.eqz
        br_if 0 (;@2;)
        local.get 5
        i32.load offset=4
        local.set 49
        local.get 5
        i32.load offset=12
        local.set 50
        local.get 5
        i32.load offset=8
        local.set 51
        local.get 49
        local.get 50
        local.get 51
        call $strncpy
        drop
        local.get 5
        i32.load offset=4
        local.set 52
        local.get 5
        i32.load offset=8
        local.set 53
        local.get 52
        local.get 53
        i32.add
        local.set 54
        i32.const 0
        local.set 55
        local.get 54
        local.get 55
        i32.store8
        br 1 (;@1;)
      end
      local.get 5
      i32.load offset=4
      local.set 56
      i32.const 0
      local.set 57
      local.get 56
      local.get 57
      i32.store8
    end
    local.get 5
    i32.load offset=16
    local.set 58
    local.get 58
    call $emscripten_builtin_free
    local.get 5
    i32.load offset=12
    local.set 59
    local.get 59
    call $emscripten_builtin_free
    local.get 5
    i32.load offset=4
    local.set 60
    i32.const 32
    local.set 61
    local.get 5
    local.get 61
    i32.add
    local.set 62
    local.get 62
    global.set $__stack_pointer
    local.get 60
    return)
  (func $hash (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 f64 f64 f64 i32 i32 i32 i32 f64 f64 f64 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 1
    i32.const 16
    local.set 2
    local.get 1
    local.get 2
    i32.sub
    local.set 3
    local.get 3
    global.set $__stack_pointer
    local.get 3
    local.get 0
    i32.store offset=12
    local.get 3
    i32.load offset=12
    local.set 4
    local.get 4
    f64.convert_i32_s
    local.set 5
    f64.const 0x1p+1 (;=2;)
    local.set 6
    local.get 6
    local.get 5
    call $pow
    local.set 7
    local.get 7
    i32.trunc_sat_f64_s
    local.set 8
    local.get 3
    i32.load offset=12
    local.set 9
    i32.const 10
    local.set 10
    local.get 9
    local.get 10
    i32.rem_s
    local.set 11
    local.get 11
    f64.convert_i32_s
    local.set 12
    f64.const 0x1.8p+1 (;=3;)
    local.set 13
    local.get 13
    local.get 12
    call $pow
    local.set 14
    local.get 14
    i32.trunc_sat_f64_s
    local.set 15
    local.get 8
    local.get 15
    i32.add
    local.set 16
    i32.const -695828729
    local.set 17
    local.get 16
    local.get 17
    i32.rem_u
    local.set 18
    i32.const 16
    local.set 19
    local.get 3
    local.get 19
    i32.add
    local.set 20
    local.get 20
    global.set $__stack_pointer
    local.get 18
    return)
  (func $getIdx (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 1
    i32.const 16
    local.set 2
    local.get 1
    local.get 2
    i32.sub
    local.set 3
    local.get 3
    global.set $__stack_pointer
    local.get 3
    local.get 0
    i32.store offset=12
    local.get 3
    i32.load offset=12
    local.set 4
    local.get 4
    call $hash
    local.set 5
    i32.const 15
    local.set 6
    local.get 5
    local.get 6
    i32.rem_s
    local.set 7
    i32.const 16
    local.set 8
    local.get 3
    local.get 8
    i32.add
    local.set 9
    local.get 9
    global.set $__stack_pointer
    local.get 7
    return)
  (func $getTblIdx (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 32
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=24
    local.get 4
    local.get 1
    i32.store offset=20
    local.get 4
    i32.load offset=20
    local.set 5
    local.get 5
    i32.load
    local.set 6
    local.get 6
    call $getIdx
    local.set 7
    local.get 4
    local.get 7
    i32.store offset=16
    i32.const 0
    local.set 8
    local.get 4
    local.get 8
    i32.store offset=12
    local.get 4
    i32.load offset=16
    local.set 9
    i32.const 1
    local.set 10
    local.get 10
    local.get 9
    i32.shl
    local.set 11
    local.get 4
    local.get 11
    i32.store offset=8
    local.get 4
    i32.load offset=24
    local.set 12
    local.get 12
    i32.load
    local.set 13
    local.get 4
    i32.load offset=8
    local.set 14
    local.get 13
    local.get 14
    i32.and
    local.set 15
    block  ;; label = @1
      block  ;; label = @2
        local.get 15
        i32.eqz
        br_if 0 (;@2;)
        local.get 4
        i32.load offset=24
        local.set 16
        i32.const 8
        local.set 17
        local.get 16
        local.get 17
        i32.add
        local.set 18
        local.get 4
        i32.load offset=16
        local.set 19
        i32.const 2
        local.set 20
        local.get 19
        local.get 20
        i32.shl
        local.set 21
        local.get 18
        local.get 21
        i32.add
        local.set 22
        local.get 22
        i32.load
        local.set 23
        local.get 23
        i32.load offset=4
        local.set 24
        local.get 24
        i32.load offset=16
        local.set 25
        local.get 4
        i32.load offset=20
        local.set 26
        local.get 26
        i32.load offset=16
        local.set 27
        local.get 25
        local.get 27
        i32.sub
        local.set 28
        i32.const 60
        local.set 29
        local.get 28
        local.get 29
        i32.gt_s
        local.set 30
        i32.const 1
        local.set 31
        local.get 30
        local.get 31
        i32.and
        local.set 32
        block  ;; label = @3
          local.get 32
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          i32.load offset=24
          local.set 33
          i32.const 8
          local.set 34
          local.get 33
          local.get 34
          i32.add
          local.set 35
          local.get 4
          i32.load offset=16
          local.set 36
          i32.const 2
          local.set 37
          local.get 36
          local.get 37
          i32.shl
          local.set 38
          local.get 35
          local.get 38
          i32.add
          local.set 39
          local.get 39
          i32.load
          local.set 40
          local.get 40
          i32.load offset=4
          local.set 41
          i32.const 0
          local.set 42
          local.get 41
          local.get 42
          i32.store offset=4
          local.get 4
          i32.load offset=24
          local.set 43
          local.get 43
          i32.load
          local.set 44
          local.get 4
          i32.load offset=8
          local.set 45
          i32.const -1
          local.set 46
          local.get 45
          local.get 46
          i32.xor
          local.set 47
          i32.const 65535
          local.set 48
          local.get 47
          local.get 48
          i32.and
          local.set 49
          local.get 44
          local.get 49
          i32.and
          local.set 50
          local.get 4
          i32.load offset=24
          local.set 51
          local.get 51
          local.get 50
          i32.store
        end
        block  ;; label = @3
          loop  ;; label = @4
            local.get 4
            i32.load offset=24
            local.set 52
            local.get 52
            i32.load
            local.set 53
            local.get 4
            i32.load offset=8
            local.set 54
            local.get 53
            local.get 54
            i32.and
            local.set 55
            local.get 55
            i32.eqz
            br_if 1 (;@3;)
            local.get 4
            i32.load offset=16
            local.set 56
            i32.const 1
            local.set 57
            local.get 56
            local.get 57
            i32.add
            local.set 58
            i32.const 15
            local.set 59
            local.get 58
            local.get 59
            i32.rem_s
            local.set 60
            local.get 4
            local.get 60
            i32.store offset=16
            local.get 4
            i32.load offset=8
            local.set 61
            i32.const 1
            local.set 62
            local.get 61
            local.get 62
            i32.shl
            local.set 63
            local.get 4
            i32.load offset=8
            local.set 64
            i32.const 14
            local.set 65
            local.get 64
            local.get 65
            i32.shr_s
            local.set 66
            local.get 63
            local.get 66
            i32.or
            local.set 67
            i32.const 32767
            local.set 68
            local.get 67
            local.get 68
            i32.and
            local.set 69
            local.get 4
            local.get 69
            i32.store offset=8
            local.get 4
            i32.load offset=12
            local.set 70
            i32.const 1
            local.set 71
            local.get 70
            local.get 71
            i32.add
            local.set 72
            local.get 4
            local.get 72
            i32.store offset=12
            local.get 4
            i32.load offset=12
            local.set 73
            i32.const 15
            local.set 74
            local.get 73
            local.get 74
            i32.gt_s
            local.set 75
            i32.const 1
            local.set 76
            local.get 75
            local.get 76
            i32.and
            local.set 77
            block  ;; label = @5
              local.get 77
              i32.eqz
              br_if 0 (;@5;)
              i32.const -1
              local.set 78
              local.get 4
              local.get 78
              i32.store offset=28
              br 4 (;@1;)
            end
            br 0 (;@4;)
          end
        end
      end
      local.get 4
      i32.load offset=8
      local.set 79
      local.get 4
      i32.load offset=24
      local.set 80
      local.get 80
      i32.load
      local.set 81
      local.get 81
      local.get 79
      i32.or
      local.set 82
      local.get 80
      local.get 82
      i32.store
      local.get 4
      i32.load offset=16
      local.set 83
      local.get 4
      local.get 83
      i32.store offset=28
    end
    local.get 4
    i32.load offset=28
    local.set 84
    i32.const 32
    local.set 85
    local.get 4
    local.get 85
    i32.add
    local.set 86
    local.get 86
    global.set $__stack_pointer
    local.get 84
    return)
  (func $tryPutMsgCache (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 32
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=24
    local.get 4
    local.get 1
    i32.store offset=20
    local.get 4
    i32.load offset=24
    local.set 5
    local.get 4
    i32.load offset=20
    local.set 6
    local.get 5
    local.get 6
    call $getTblIdx
    local.set 7
    local.get 4
    local.get 7
    i32.store offset=16
    local.get 4
    i32.load offset=16
    local.set 8
    i32.const -1
    local.set 9
    local.get 8
    local.get 9
    i32.ne
    local.set 10
    i32.const 1
    local.set 11
    local.get 10
    local.get 11
    i32.and
    local.set 12
    block  ;; label = @1
      block  ;; label = @2
        local.get 12
        i32.eqz
        br_if 0 (;@2;)
        i32.const 4
        local.set 13
        local.get 13
        call $emscripten_builtin_malloc
        local.set 14
        local.get 4
        local.get 14
        i32.store offset=8
        local.get 4
        i32.load offset=20
        local.set 15
        local.get 15
        i32.load offset=8
        local.set 16
        local.get 4
        i32.load offset=20
        local.set 17
        local.get 17
        i32.load offset=12
        local.set 18
        i32.const 12
        local.set 19
        local.get 4
        local.get 19
        i32.add
        local.set 20
        local.get 20
        local.set 21
        local.get 16
        local.get 18
        local.get 21
        call $sanitize
        local.set 22
        local.get 4
        i32.load offset=8
        local.set 23
        local.get 23
        local.get 22
        i32.store
        local.get 4
        i32.load offset=20
        local.set 24
        local.get 24
        i32.load
        local.set 25
        local.get 4
        i32.load offset=8
        local.set 26
        local.get 26
        local.get 25
        i32.store offset=8
        local.get 4
        i32.load offset=20
        local.set 27
        local.get 4
        i32.load offset=8
        local.set 28
        local.get 28
        local.get 27
        i32.store offset=4
        local.get 4
        i32.load offset=8
        local.set 29
        local.get 4
        i32.load offset=24
        local.set 30
        i32.const 8
        local.set 31
        local.get 30
        local.get 31
        i32.add
        local.set 32
        local.get 4
        i32.load offset=16
        local.set 33
        i32.const 2
        local.set 34
        local.get 33
        local.get 34
        i32.shl
        local.set 35
        local.get 32
        local.get 35
        i32.add
        local.set 36
        local.get 36
        local.get 29
        i32.store
        local.get 4
        i32.load offset=12
        local.set 37
        local.get 4
        i32.load offset=24
        local.set 38
        i32.const 136
        local.set 39
        local.get 38
        local.get 39
        i32.add
        local.set 40
        local.get 4
        i32.load offset=16
        local.set 41
        i32.const 2
        local.set 42
        local.get 41
        local.get 42
        i32.shl
        local.set 43
        local.get 40
        local.get 43
        i32.add
        local.set 44
        local.get 44
        local.get 37
        i32.store
        i32.const 1
        local.set 45
        local.get 4
        local.get 45
        i32.store offset=28
        br 1 (;@1;)
      end
      i32.const 0
      local.set 46
      local.get 4
      local.get 46
      i32.store offset=28
    end
    local.get 4
    i32.load offset=28
    local.set 47
    i32.const 32
    local.set 48
    local.get 4
    local.get 48
    i32.add
    local.set 49
    local.get 49
    global.set $__stack_pointer
    local.get 47
    return)
  (func $tryUpdateMsgCache (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 3
    i32.const 32
    local.set 4
    local.get 3
    local.get 4
    i32.sub
    local.set 5
    local.get 5
    global.set $__stack_pointer
    local.get 5
    local.get 0
    i32.store offset=24
    local.get 5
    local.get 1
    i32.store offset=20
    local.get 5
    local.get 2
    i32.store offset=16
    local.get 5
    i32.load offset=24
    local.set 6
    i32.const 8
    local.set 7
    local.get 6
    local.get 7
    i32.add
    local.set 8
    local.get 5
    i32.load offset=16
    local.set 9
    i32.const 2
    local.set 10
    local.get 9
    local.get 10
    i32.shl
    local.set 11
    local.get 8
    local.get 11
    i32.add
    local.set 12
    local.get 12
    i32.load
    local.set 13
    local.get 5
    local.get 13
    i32.store offset=8
    local.get 5
    i32.load offset=20
    local.set 14
    local.get 14
    i32.load offset=8
    local.set 15
    local.get 5
    i32.load offset=20
    local.set 16
    local.get 16
    i32.load offset=12
    local.set 17
    i32.const 12
    local.set 18
    local.get 5
    local.get 18
    i32.add
    local.set 19
    local.get 19
    local.set 20
    local.get 15
    local.get 17
    local.get 20
    call $sanitize
    local.set 21
    local.get 5
    local.get 21
    i32.store offset=4
    local.get 5
    i32.load offset=12
    local.set 22
    local.get 5
    i32.load offset=24
    local.set 23
    i32.const 136
    local.set 24
    local.get 23
    local.get 24
    i32.add
    local.set 25
    local.get 5
    i32.load offset=16
    local.set 26
    i32.const 2
    local.set 27
    local.get 26
    local.get 27
    i32.shl
    local.set 28
    local.get 25
    local.get 28
    i32.add
    local.set 29
    local.get 29
    i32.load
    local.set 30
    local.get 22
    local.get 30
    i32.le_u
    local.set 31
    i32.const 1
    local.set 32
    local.get 31
    local.get 32
    i32.and
    local.set 33
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 33
          i32.eqz
          br_if 0 (;@3;)
          local.get 5
          i32.load offset=8
          local.set 34
          local.get 34
          i32.load
          local.set 35
          local.get 5
          i32.load offset=4
          local.set 36
          local.get 5
          i32.load offset=12
          local.set 37
          local.get 37
          i32.eqz
          local.set 38
          block  ;; label = @4
            local.get 38
            br_if 0 (;@4;)
            local.get 35
            local.get 36
            local.get 37
            memory.copy
          end
          local.get 5
          i32.load offset=4
          local.set 39
          local.get 39
          call $emscripten_builtin_free
          local.get 5
          i32.load offset=12
          local.set 40
          local.get 5
          i32.load offset=24
          local.set 41
          i32.const 136
          local.set 42
          local.get 41
          local.get 42
          i32.add
          local.set 43
          local.get 5
          i32.load offset=16
          local.set 44
          i32.const 2
          local.set 45
          local.get 44
          local.get 45
          i32.shl
          local.set 46
          local.get 43
          local.get 46
          i32.add
          local.set 47
          local.get 47
          i32.load
          local.set 48
          local.get 40
          local.get 48
          i32.lt_u
          local.set 49
          i32.const 1
          local.set 50
          local.get 49
          local.get 50
          i32.and
          local.set 51
          block  ;; label = @4
            local.get 51
            i32.eqz
            br_if 0 (;@4;)
            local.get 5
            i32.load offset=8
            local.set 52
            local.get 52
            i32.load
            local.set 53
            local.get 5
            i32.load offset=12
            local.set 54
            local.get 53
            local.get 54
            i32.add
            local.set 55
            i32.const 0
            local.set 56
            local.get 55
            local.get 56
            i32.store8
          end
          br 1 (;@2;)
        end
        local.get 5
        i32.load offset=20
        local.set 57
        local.get 5
        i32.load offset=8
        local.set 58
        local.get 58
        local.get 57
        i32.store offset=4
        local.get 5
        i32.load offset=12
        local.set 59
        local.get 5
        i32.load offset=24
        local.set 60
        i32.const 136
        local.set 61
        local.get 60
        local.get 61
        i32.add
        local.set 62
        local.get 5
        i32.load offset=16
        local.set 63
        i32.const 2
        local.set 64
        local.get 63
        local.get 64
        i32.shl
        local.set 65
        local.get 62
        local.get 65
        i32.add
        local.set 66
        local.get 66
        local.get 59
        i32.store
        local.get 5
        i32.load offset=8
        local.set 67
        local.get 67
        i32.load
        local.set 68
        local.get 68
        call $emscripten_builtin_free
        local.get 5
        i32.load offset=4
        local.set 69
        local.get 5
        i32.load offset=8
        local.set 70
        local.get 70
        local.get 69
        i32.store
        i32.const 0
        local.set 71
        local.get 5
        local.get 71
        i32.store offset=28
        br 1 (;@1;)
      end
      local.get 5
      i32.load offset=8
      local.set 72
      local.get 5
      i32.load offset=24
      local.set 73
      i32.const 8
      local.set 74
      local.get 73
      local.get 74
      i32.add
      local.set 75
      local.get 5
      i32.load offset=16
      local.set 76
      i32.const 2
      local.set 77
      local.get 76
      local.get 77
      i32.shl
      local.set 78
      local.get 75
      local.get 78
      i32.add
      local.set 79
      local.get 79
      local.get 72
      i32.store
      i32.const 0
      local.set 80
      local.get 5
      local.get 80
      i32.store offset=28
    end
    local.get 5
    i32.load offset=28
    local.set 81
    i32.const 32
    local.set 82
    local.get 5
    local.get 82
    i32.add
    local.set 83
    local.get 83
    global.set $__stack_pointer
    local.get 81
    return)
  (func $getFromCacheTable (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 32
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=24
    local.get 4
    local.get 1
    i32.store offset=20
    local.get 4
    i32.load offset=20
    local.set 5
    local.get 5
    call $getIdx
    local.set 6
    local.get 4
    local.get 6
    i32.store offset=16
    i32.const 0
    local.set 7
    local.get 4
    local.get 7
    i32.store offset=12
    local.get 4
    i32.load offset=16
    local.set 8
    i32.const 1
    local.set 9
    local.get 9
    local.get 8
    i32.shl
    local.set 10
    local.get 4
    local.get 10
    i32.store offset=8
    local.get 4
    i32.load offset=24
    local.set 11
    i32.const 8
    local.set 12
    local.get 11
    local.get 12
    i32.add
    local.set 13
    local.get 4
    local.get 13
    i32.store offset=4
    block  ;; label = @1
      loop  ;; label = @2
        local.get 4
        i32.load offset=4
        local.set 14
        local.get 4
        i32.load offset=16
        local.set 15
        i32.const 2
        local.set 16
        local.get 15
        local.get 16
        i32.shl
        local.set 17
        local.get 14
        local.get 17
        i32.add
        local.set 18
        local.get 18
        i32.load
        local.set 19
        local.get 19
        i32.load offset=8
        local.set 20
        local.get 4
        i32.load offset=20
        local.set 21
        local.get 20
        local.get 21
        i32.eq
        local.set 22
        i32.const 1
        local.set 23
        local.get 22
        local.get 23
        i32.and
        local.set 24
        block  ;; label = @3
          local.get 24
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          i32.load offset=16
          local.set 25
          local.get 4
          local.get 25
          i32.store offset=28
          br 2 (;@1;)
        end
        local.get 4
        i32.load offset=16
        local.set 26
        i32.const 1
        local.set 27
        local.get 26
        local.get 27
        i32.add
        local.set 28
        i32.const 15
        local.set 29
        local.get 28
        local.get 29
        i32.rem_s
        local.set 30
        local.get 4
        local.get 30
        i32.store offset=16
        local.get 4
        i32.load offset=8
        local.set 31
        i32.const 1
        local.set 32
        local.get 31
        local.get 32
        i32.shl
        local.set 33
        local.get 4
        i32.load offset=8
        local.set 34
        i32.const 14
        local.set 35
        local.get 34
        local.get 35
        i32.shr_s
        local.set 36
        local.get 33
        local.get 36
        i32.or
        local.set 37
        i32.const 32767
        local.set 38
        local.get 37
        local.get 38
        i32.and
        local.set 39
        local.get 4
        local.get 39
        i32.store offset=8
        local.get 4
        i32.load offset=12
        local.set 40
        i32.const 1
        local.set 41
        local.get 40
        local.get 41
        i32.add
        local.set 42
        local.get 4
        local.get 42
        i32.store offset=12
        local.get 4
        i32.load offset=12
        local.set 43
        i32.const 15
        local.set 44
        local.get 43
        local.get 44
        i32.gt_s
        local.set 45
        i32.const 1
        local.set 46
        local.get 45
        local.get 46
        i32.and
        local.set 47
        block  ;; label = @3
          block  ;; label = @4
            local.get 47
            i32.eqz
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          br 1 (;@2;)
        end
      end
      i32.const -2
      local.set 48
      local.get 4
      local.get 48
      i32.store offset=28
    end
    local.get 4
    i32.load offset=28
    local.set 49
    i32.const 32
    local.set 50
    local.get 4
    local.get 50
    i32.add
    local.set 51
    local.get 51
    global.set $__stack_pointer
    local.get 49
    return)
  (func $findnInvalidate (type 4) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 16
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=12
    local.get 4
    local.get 1
    i32.store offset=8
    local.get 4
    i32.load offset=12
    local.set 5
    local.get 4
    i32.load offset=8
    local.set 6
    local.get 5
    local.get 6
    call $getFromCacheTable
    local.set 7
    local.get 4
    local.get 7
    i32.store offset=4
    local.get 4
    i32.load offset=4
    local.set 8
    i32.const -2
    local.set 9
    local.get 8
    local.get 9
    i32.ne
    local.set 10
    i32.const 1
    local.set 11
    local.get 10
    local.get 11
    i32.and
    local.set 12
    block  ;; label = @1
      local.get 12
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      i32.load offset=12
      local.set 13
      i32.const 8
      local.set 14
      local.get 13
      local.get 14
      i32.add
      local.set 15
      local.get 4
      i32.load offset=4
      local.set 16
      i32.const 2
      local.set 17
      local.get 16
      local.get 17
      i32.shl
      local.set 18
      local.get 15
      local.get 18
      i32.add
      local.set 19
      local.get 19
      i32.load
      local.set 20
      local.get 20
      i32.load offset=4
      local.set 21
      i32.const 0
      local.set 22
      local.get 21
      local.get 22
      i32.store offset=4
      local.get 4
      i32.load offset=12
      local.set 23
      local.get 23
      i32.load
      local.set 24
      local.get 4
      i32.load offset=4
      local.set 25
      i32.const 1
      local.set 26
      local.get 26
      local.get 25
      i32.shl
      local.set 27
      i32.const -1
      local.set 28
      local.get 27
      local.get 28
      i32.xor
      local.set 29
      local.get 24
      local.get 29
      i32.and
      local.set 30
      i32.const 65535
      local.set 31
      local.get 30
      local.get 31
      i32.and
      local.set 32
      local.get 4
      i32.load offset=12
      local.set 33
      local.get 33
      local.get 32
      i32.store
    end
    i32.const 16
    local.set 34
    local.get 4
    local.get 34
    i32.add
    local.set 35
    local.get 35
    global.set $__stack_pointer
    return)
  (func $add_msg_to_stuff (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i32 i32 i32 i32 i32 i32 i32 i64 i32 i32 i32 i64 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 16
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=12
    local.get 4
    i32.load offset=12
    local.set 5
    local.get 5
    i32.load offset=12
    local.set 6
    local.get 4
    i32.load offset=12
    local.set 7
    local.get 7
    i32.load offset=16
    local.set 8
    local.get 6
    local.get 8
    i32.ge_s
    local.set 9
    i32.const 1
    local.set 10
    local.get 9
    local.get 10
    i32.and
    local.set 11
    block  ;; label = @1
      local.get 11
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      i32.load offset=12
      local.set 12
      local.get 12
      i32.load offset=16
      local.set 13
      i32.const 1
      local.set 14
      local.get 13
      local.get 14
      i32.shl
      local.set 15
      local.get 12
      local.get 15
      i32.store offset=16
      local.get 4
      i32.load offset=12
      local.set 16
      local.get 16
      i32.load offset=8
      local.set 17
      local.get 4
      i32.load offset=12
      local.set 18
      local.get 18
      i32.load offset=16
      local.set 19
      i32.const 28
      local.set 20
      local.get 19
      local.get 20
      i32.mul
      local.set 21
      local.get 17
      local.get 21
      call $emscripten_builtin_realloc
      local.set 22
      local.get 4
      i32.load offset=12
      local.set 23
      local.get 23
      local.get 22
      i32.store offset=8
      local.get 4
      i32.load offset=12
      local.set 24
      local.get 24
      i32.load offset=8
      local.set 25
      i32.const 0
      local.set 26
      local.get 25
      local.get 26
      i32.eq
      local.set 27
      i32.const 1
      local.set 28
      local.get 27
      local.get 28
      i32.and
      local.set 29
      block  ;; label = @2
        local.get 29
        i32.eqz
        br_if 0 (;@2;)
        i32.const 1
        local.set 30
        local.get 30
        call $exit
        unreachable
      end
    end
    local.get 4
    i32.load offset=12
    local.set 31
    local.get 31
    i32.load offset=8
    local.set 32
    local.get 4
    i32.load offset=12
    local.set 33
    local.get 33
    i32.load offset=12
    local.set 34
    i32.const 1
    local.set 35
    local.get 34
    local.get 35
    i32.add
    local.set 36
    local.get 33
    local.get 36
    i32.store offset=12
    i32.const 28
    local.set 37
    local.get 34
    local.get 37
    i32.mul
    local.set 38
    local.get 32
    local.get 38
    i32.add
    local.set 39
    local.get 1
    i64.load align=4
    local.set 40
    local.get 39
    local.get 40
    i64.store align=4
    i32.const 24
    local.set 41
    local.get 39
    local.get 41
    i32.add
    local.set 42
    local.get 1
    local.get 41
    i32.add
    local.set 43
    local.get 43
    i32.load
    local.set 44
    local.get 42
    local.get 44
    i32.store
    i32.const 16
    local.set 45
    local.get 39
    local.get 45
    i32.add
    local.set 46
    local.get 1
    local.get 45
    i32.add
    local.set 47
    local.get 47
    i64.load align=4
    local.set 48
    local.get 46
    local.get 48
    i64.store align=4
    i32.const 8
    local.set 49
    local.get 39
    local.get 49
    i32.add
    local.set 50
    local.get 1
    local.get 49
    i32.add
    local.set 51
    local.get 51
    i64.load align=4
    local.set 52
    local.get 50
    local.get 52
    i64.store align=4
    local.get 4
    i32.load offset=12
    local.set 53
    local.get 53
    i32.load offset=12
    local.set 54
    i32.const 1
    local.set 55
    local.get 54
    local.get 55
    i32.sub
    local.set 56
    i32.const 16
    local.set 57
    local.get 4
    local.get 57
    i32.add
    local.set 58
    local.get 58
    global.set $__stack_pointer
    local.get 56
    return)
  (func $initialize (type 7)
    (local i32)
    i32.const 75124
    local.set 0
    local.get 0
    call $init_stuff
    call $initCacheTable
    return)
  (func $populateMsgHTML (type 1) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 1
    i32.const 32
    local.set 2
    local.get 1
    local.get 2
    i32.sub
    local.set 3
    local.get 3
    global.set $__stack_pointer
    local.get 3
    local.get 0
    i32.store offset=28
    i32.const 0
    local.set 4
    local.get 3
    local.get 4
    i32.store offset=24
    i32.const 0
    local.set 5
    local.get 3
    local.get 5
    i32.store offset=24
    block  ;; label = @1
      loop  ;; label = @2
        local.get 3
        i32.load offset=24
        local.set 6
        i32.const 0
        local.set 7
        local.get 7
        i32.load offset=75136
        local.set 8
        local.get 6
        local.get 8
        i32.lt_s
        local.set 9
        i32.const 1
        local.set 10
        local.get 9
        local.get 10
        i32.and
        local.set 11
        local.get 11
        i32.eqz
        br_if 1 (;@1;)
        i32.const 0
        local.set 12
        local.get 12
        i32.load offset=75132
        local.set 13
        local.get 3
        i32.load offset=24
        local.set 14
        i32.const 28
        local.set 15
        local.get 14
        local.get 15
        i32.mul
        local.set 16
        local.get 13
        local.get 16
        i32.add
        local.set 17
        local.get 17
        i32.load offset=24
        local.set 18
        block  ;; label = @3
          block  ;; label = @4
            local.get 18
            br_if 0 (;@4;)
            i32.const 0
            local.set 19
            local.get 19
            i32.load offset=75132
            local.set 20
            local.get 3
            i32.load offset=24
            local.set 21
            i32.const 28
            local.set 22
            local.get 21
            local.get 22
            i32.mul
            local.set 23
            local.get 20
            local.get 23
            i32.add
            local.set 24
            local.get 24
            i32.load offset=8
            local.set 25
            i32.const 0
            local.set 26
            local.get 26
            i32.load offset=75132
            local.set 27
            local.get 3
            i32.load offset=24
            local.set 28
            i32.const 28
            local.set 29
            local.get 28
            local.get 29
            i32.mul
            local.set 30
            local.get 27
            local.get 30
            i32.add
            local.set 31
            local.get 31
            i32.load offset=12
            local.set 32
            i32.const 20
            local.set 33
            local.get 3
            local.get 33
            i32.add
            local.set 34
            local.get 34
            local.set 35
            local.get 25
            local.get 32
            local.get 35
            call $sanitizeWithJs
            local.set 36
            local.get 3
            local.get 36
            i32.store offset=16
            local.get 3
            i32.load offset=16
            local.set 37
            local.get 3
            i32.load offset=20
            local.set 38
            local.get 37
            local.get 38
            call $toSafeHTML
            local.set 39
            local.get 3
            local.get 39
            i32.store offset=12
            local.get 3
            i32.load offset=28
            local.set 40
            local.get 3
            i32.load offset=12
            local.set 41
            i32.const 0
            local.set 42
            local.get 42
            i32.load offset=75132
            local.set 43
            local.get 3
            i32.load offset=24
            local.set 44
            i32.const 28
            local.set 45
            local.get 44
            local.get 45
            i32.mul
            local.set 46
            local.get 43
            local.get 46
            i32.add
            local.set 47
            local.get 47
            i32.load offset=20
            local.set 48
            i32.const 0
            local.set 49
            local.get 49
            i32.load offset=75132
            local.set 50
            local.get 3
            i32.load offset=24
            local.set 51
            i32.const 28
            local.set 52
            local.get 51
            local.get 52
            i32.mul
            local.set 53
            local.get 50
            local.get 53
            i32.add
            local.set 54
            local.get 54
            i32.load offset=16
            local.set 55
            local.get 3
            i32.load offset=24
            local.set 56
            local.get 41
            local.get 48
            local.get 55
            local.get 56
            local.get 40
            call_indirect (type 0)
            drop
            local.get 3
            i32.load offset=16
            local.set 57
            local.get 57
            call $emscripten_builtin_free
            local.get 3
            i32.load offset=12
            local.set 58
            local.get 58
            call $emscripten_builtin_free
            br 1 (;@3;)
          end
          i32.const 0
          local.set 59
          local.get 59
          i32.load offset=75132
          local.set 60
          local.get 3
          i32.load offset=24
          local.set 61
          i32.const 28
          local.set 62
          local.get 61
          local.get 62
          i32.mul
          local.set 63
          local.get 60
          local.get 63
          i32.add
          local.set 64
          local.get 64
          i32.load offset=4
          local.set 65
          block  ;; label = @4
            block  ;; label = @5
              local.get 65
              i32.eqz
              br_if 0 (;@5;)
              i32.const 0
              local.set 66
              local.get 66
              i32.load offset=75116
              local.set 67
              i32.const 0
              local.set 68
              local.get 68
              i32.load offset=75132
              local.set 69
              local.get 3
              i32.load offset=24
              local.set 70
              i32.const 28
              local.set 71
              local.get 70
              local.get 71
              i32.mul
              local.set 72
              local.get 69
              local.get 72
              i32.add
              local.set 73
              local.get 73
              i32.load
              local.set 74
              local.get 67
              local.get 74
              call $getFromCacheTable
              local.set 75
              local.get 3
              local.get 75
              i32.store offset=8
              local.get 3
              i32.load offset=8
              local.set 76
              i32.const 0
              local.set 77
              local.get 76
              local.get 77
              i32.lt_s
              local.set 78
              i32.const 1
              local.set 79
              local.get 78
              local.get 79
              i32.and
              local.set 80
              block  ;; label = @6
                local.get 80
                i32.eqz
                br_if 0 (;@6;)
                br 2 (;@4;)
              end
              i32.const 0
              local.set 81
              local.get 81
              i32.load offset=75116
              local.set 82
              i32.const 8
              local.set 83
              local.get 82
              local.get 83
              i32.add
              local.set 84
              local.get 3
              i32.load offset=8
              local.set 85
              i32.const 2
              local.set 86
              local.get 85
              local.get 86
              i32.shl
              local.set 87
              local.get 84
              local.get 87
              i32.add
              local.set 88
              local.get 88
              i32.load
              local.set 89
              local.get 89
              i32.load
              local.set 90
              local.get 3
              local.get 90
              i32.store offset=16
              i32.const 0
              local.set 91
              local.get 91
              i32.load offset=75116
              local.set 92
              i32.const 136
              local.set 93
              local.get 92
              local.get 93
              i32.add
              local.set 94
              local.get 3
              i32.load offset=8
              local.set 95
              i32.const 2
              local.set 96
              local.get 95
              local.get 96
              i32.shl
              local.set 97
              local.get 94
              local.get 97
              i32.add
              local.set 98
              local.get 98
              i32.load
              local.set 99
              local.get 3
              local.get 99
              i32.store offset=20
              local.get 3
              i32.load offset=16
              local.set 100
              local.get 3
              i32.load offset=20
              local.set 101
              local.get 100
              local.get 101
              call $toSafeHTML
              local.set 102
              local.get 3
              local.get 102
              i32.store offset=4
              local.get 3
              i32.load offset=28
              local.set 103
              local.get 3
              i32.load offset=4
              local.set 104
              i32.const 0
              local.set 105
              local.get 105
              i32.load offset=75132
              local.set 106
              local.get 3
              i32.load offset=24
              local.set 107
              i32.const 28
              local.set 108
              local.get 107
              local.get 108
              i32.mul
              local.set 109
              local.get 106
              local.get 109
              i32.add
              local.set 110
              local.get 110
              i32.load offset=20
              local.set 111
              i32.const 0
              local.set 112
              local.get 112
              i32.load offset=75132
              local.set 113
              local.get 3
              i32.load offset=24
              local.set 114
              i32.const 28
              local.set 115
              local.get 114
              local.get 115
              i32.mul
              local.set 116
              local.get 113
              local.get 116
              i32.add
              local.set 117
              local.get 117
              i32.load offset=16
              local.set 118
              local.get 3
              i32.load offset=24
              local.set 119
              local.get 104
              local.get 111
              local.get 118
              local.get 119
              local.get 103
              call_indirect (type 0)
              drop
              local.get 3
              i32.load offset=4
              local.set 120
              local.get 120
              call $emscripten_builtin_free
              br 2 (;@3;)
            end
          end
          i32.const 0
          local.set 121
          local.get 121
          i32.load offset=75132
          local.set 122
          local.get 3
          i32.load offset=24
          local.set 123
          i32.const 28
          local.set 124
          local.get 123
          local.get 124
          i32.mul
          local.set 125
          local.get 122
          local.get 125
          i32.add
          local.set 126
          local.get 126
          i32.load offset=8
          local.set 127
          i32.const 0
          local.set 128
          local.get 128
          i32.load offset=75132
          local.set 129
          local.get 3
          i32.load offset=24
          local.set 130
          i32.const 28
          local.set 131
          local.get 130
          local.get 131
          i32.mul
          local.set 132
          local.get 129
          local.get 132
          i32.add
          local.set 133
          local.get 133
          i32.load offset=12
          local.set 134
          i32.const 20
          local.set 135
          local.get 3
          local.get 135
          i32.add
          local.set 136
          local.get 136
          local.set 137
          local.get 127
          local.get 134
          local.get 137
          call $sanitize
          local.set 138
          local.get 3
          local.get 138
          i32.store offset=16
          local.get 3
          i32.load offset=16
          local.set 139
          local.get 3
          i32.load offset=20
          local.set 140
          local.get 139
          local.get 140
          call $toSafeHTML
          local.set 141
          local.get 3
          local.get 141
          i32.store
          local.get 3
          i32.load offset=28
          local.set 142
          local.get 3
          i32.load
          local.set 143
          i32.const 0
          local.set 144
          local.get 144
          i32.load offset=75132
          local.set 145
          local.get 3
          i32.load offset=24
          local.set 146
          i32.const 28
          local.set 147
          local.get 146
          local.get 147
          i32.mul
          local.set 148
          local.get 145
          local.get 148
          i32.add
          local.set 149
          local.get 149
          i32.load offset=20
          local.set 150
          i32.const 0
          local.set 151
          local.get 151
          i32.load offset=75132
          local.set 152
          local.get 3
          i32.load offset=24
          local.set 153
          i32.const 28
          local.set 154
          local.get 153
          local.get 154
          i32.mul
          local.set 155
          local.get 152
          local.get 155
          i32.add
          local.set 156
          local.get 156
          i32.load offset=16
          local.set 157
          local.get 3
          i32.load offset=24
          local.set 158
          local.get 143
          local.get 150
          local.get 157
          local.get 158
          local.get 142
          call_indirect (type 0)
          drop
          local.get 3
          i32.load
          local.set 159
          local.get 159
          call $emscripten_builtin_free
          local.get 3
          i32.load offset=16
          local.set 160
          local.get 160
          call $emscripten_builtin_free
        end
        local.get 3
        i32.load offset=24
        local.set 161
        i32.const 1
        local.set 162
        local.get 161
        local.get 162
        i32.add
        local.set 163
        local.get 3
        local.get 163
        i32.store offset=24
        br 0 (;@2;)
      end
    end
    i32.const 32
    local.set 164
    local.get 3
    local.get 164
    i32.add
    local.set 165
    local.get 165
    global.set $__stack_pointer
    return)
  (func $renderHtml (type 4) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 32
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=28
    local.get 4
    local.get 1
    i32.store offset=24
    i32.const 0
    local.set 5
    local.get 5
    i32.load offset=75132
    local.set 6
    local.get 4
    i32.load offset=28
    local.set 7
    i32.const 28
    local.set 8
    local.get 7
    local.get 8
    i32.mul
    local.set 9
    local.get 6
    local.get 9
    i32.add
    local.set 10
    local.get 10
    i32.load offset=8
    local.set 11
    i32.const 0
    local.set 12
    local.get 12
    i32.load offset=75132
    local.set 13
    local.get 4
    i32.load offset=28
    local.set 14
    i32.const 28
    local.set 15
    local.get 14
    local.get 15
    i32.mul
    local.set 16
    local.get 13
    local.get 16
    i32.add
    local.set 17
    local.get 17
    i32.load offset=12
    local.set 18
    i32.const 20
    local.set 19
    local.get 4
    local.get 19
    i32.add
    local.set 20
    local.get 20
    local.set 21
    local.get 11
    local.get 18
    local.get 21
    call $sanitizeWithJs
    local.set 22
    local.get 4
    local.get 22
    i32.store offset=16
    i32.const 0
    local.set 23
    local.get 23
    i32.load offset=75132
    local.set 24
    local.get 4
    i32.load offset=28
    local.set 25
    i32.const 28
    local.set 26
    local.get 25
    local.get 26
    i32.mul
    local.set 27
    local.get 24
    local.get 27
    i32.add
    local.set 28
    i32.const 0
    local.set 29
    local.get 28
    local.get 29
    i32.store offset=24
    local.get 4
    i32.load offset=16
    local.set 30
    local.get 4
    i32.load offset=20
    local.set 31
    local.get 30
    local.get 31
    call $toSafeHTML
    local.set 32
    local.get 4
    local.get 32
    i32.store offset=12
    local.get 4
    i32.load offset=24
    local.set 33
    local.get 4
    i32.load offset=12
    local.set 34
    i32.const 0
    local.set 35
    local.get 35
    i32.load offset=75132
    local.set 36
    local.get 4
    i32.load offset=28
    local.set 37
    i32.const 28
    local.set 38
    local.get 37
    local.get 38
    i32.mul
    local.set 39
    local.get 36
    local.get 39
    i32.add
    local.set 40
    local.get 40
    i32.load offset=20
    local.set 41
    i32.const 0
    local.set 42
    local.get 42
    i32.load offset=75132
    local.set 43
    local.get 4
    i32.load offset=28
    local.set 44
    i32.const 28
    local.set 45
    local.get 44
    local.get 45
    i32.mul
    local.set 46
    local.get 43
    local.get 46
    i32.add
    local.set 47
    local.get 47
    i32.load offset=16
    local.set 48
    local.get 4
    i32.load offset=28
    local.set 49
    local.get 34
    local.get 41
    local.get 48
    local.get 49
    local.get 33
    call_indirect (type 0)
    drop
    local.get 4
    i32.load offset=12
    local.set 50
    local.get 50
    call $emscripten_builtin_free
    local.get 4
    i32.load offset=16
    local.set 51
    local.get 51
    call $emscripten_builtin_free
    i32.const 32
    local.set 52
    local.get 4
    local.get 52
    i32.add
    local.set 53
    local.get 53
    global.set $__stack_pointer
    return)
  (func $renderText (type 4) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 32
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=28
    local.get 4
    local.get 1
    i32.store offset=24
    i32.const 0
    local.set 5
    local.get 5
    i32.load offset=75132
    local.set 6
    local.get 4
    i32.load offset=28
    local.set 7
    i32.const 28
    local.set 8
    local.get 7
    local.get 8
    i32.mul
    local.set 9
    local.get 6
    local.get 9
    i32.add
    local.set 10
    local.get 10
    i32.load offset=8
    local.set 11
    i32.const 0
    local.set 12
    local.get 12
    i32.load offset=75132
    local.set 13
    local.get 4
    i32.load offset=28
    local.set 14
    i32.const 28
    local.set 15
    local.get 14
    local.get 15
    i32.mul
    local.set 16
    local.get 13
    local.get 16
    i32.add
    local.set 17
    local.get 17
    i32.load offset=12
    local.set 18
    i32.const 20
    local.set 19
    local.get 4
    local.get 19
    i32.add
    local.set 20
    local.get 20
    local.set 21
    local.get 11
    local.get 18
    local.get 21
    call $sanitize
    local.set 22
    local.get 4
    local.get 22
    i32.store offset=16
    i32.const 0
    local.set 23
    local.get 23
    i32.load offset=75132
    local.set 24
    local.get 4
    i32.load offset=28
    local.set 25
    i32.const 28
    local.set 26
    local.get 25
    local.get 26
    i32.mul
    local.set 27
    local.get 24
    local.get 27
    i32.add
    local.set 28
    i32.const 1
    local.set 29
    local.get 28
    local.get 29
    i32.store offset=24
    local.get 4
    i32.load offset=16
    local.set 30
    local.get 4
    i32.load offset=20
    local.set 31
    local.get 30
    local.get 31
    call $toSafeHTML
    local.set 32
    local.get 4
    local.get 32
    i32.store offset=12
    local.get 4
    i32.load offset=24
    local.set 33
    local.get 4
    i32.load offset=12
    local.set 34
    i32.const 0
    local.set 35
    local.get 35
    i32.load offset=75132
    local.set 36
    local.get 4
    i32.load offset=28
    local.set 37
    i32.const 28
    local.set 38
    local.get 37
    local.get 38
    i32.mul
    local.set 39
    local.get 36
    local.get 39
    i32.add
    local.set 40
    local.get 40
    i32.load offset=20
    local.set 41
    i32.const 0
    local.set 42
    local.get 42
    i32.load offset=75132
    local.set 43
    local.get 4
    i32.load offset=28
    local.set 44
    i32.const 28
    local.set 45
    local.get 44
    local.get 45
    i32.mul
    local.set 46
    local.get 43
    local.get 46
    i32.add
    local.set 47
    local.get 47
    i32.load offset=16
    local.set 48
    local.get 4
    i32.load offset=28
    local.set 49
    local.get 34
    local.get 41
    local.get 48
    local.get 49
    local.get 33
    call_indirect (type 0)
    drop
    local.get 4
    i32.load offset=16
    local.set 50
    local.get 50
    call $emscripten_builtin_free
    local.get 4
    i32.load offset=12
    local.set 51
    local.get 51
    call $emscripten_builtin_free
    i32.const 32
    local.set 52
    local.get 4
    local.get 52
    i32.add
    local.set 53
    local.get 53
    global.set $__stack_pointer
    return)
  (func $addMsg (type 0) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i32 i32 i32 i32 i32 i32 i32 i64 i64 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 4
    i32.const 96
    local.set 5
    local.get 4
    local.get 5
    i32.sub
    local.set 6
    local.get 6
    global.set $__stack_pointer
    local.get 6
    local.get 0
    i32.store offset=88
    local.get 6
    local.get 1
    i32.store offset=84
    local.get 6
    local.get 2
    i32.store offset=80
    local.get 6
    local.get 3
    i32.store offset=76
    local.get 6
    i32.load offset=84
    local.set 7
    i32.const 150
    local.set 8
    local.get 7
    local.get 8
    i32.gt_u
    local.set 9
    i32.const 1
    local.set 10
    local.get 9
    local.get 10
    i32.and
    local.set 11
    block  ;; label = @1
      block  ;; label = @2
        local.get 11
        i32.eqz
        br_if 0 (;@2;)
        i32.const -1
        local.set 12
        local.get 6
        local.get 12
        i32.store offset=92
        br 1 (;@1;)
      end
      local.get 6
      i32.load offset=84
      local.set 13
      i32.const 1
      local.set 14
      local.get 13
      local.get 14
      i32.add
      local.set 15
      local.get 15
      call $emscripten_builtin_malloc
      local.set 16
      local.get 6
      local.get 16
      i32.store offset=72
      local.get 6
      i32.load offset=72
      local.set 17
      local.get 6
      i32.load offset=84
      local.set 18
      i32.const 1
      local.set 19
      local.get 18
      local.get 19
      i32.add
      local.set 20
      i32.const 0
      local.set 21
      local.get 20
      i32.eqz
      local.set 22
      block  ;; label = @2
        local.get 22
        br_if 0 (;@2;)
        local.get 17
        local.get 21
        local.get 20
        memory.fill
      end
      local.get 6
      i32.load offset=72
      local.set 23
      local.get 6
      i32.load offset=88
      local.set 24
      local.get 6
      i32.load offset=84
      local.set 25
      local.get 23
      local.get 24
      local.get 25
      call $strncpy
      drop
      local.get 6
      i32.load offset=72
      local.set 26
      local.get 6
      local.get 26
      i32.store offset=52
      local.get 6
      i32.load offset=84
      local.set 27
      local.get 6
      local.get 27
      i32.store offset=56
      local.get 6
      i32.load offset=80
      local.set 28
      local.get 6
      local.get 28
      i32.store offset=60
      local.get 6
      i32.load offset=76
      local.set 29
      local.get 6
      local.get 29
      i32.store offset=64
      i32.const 0
      local.set 30
      local.get 30
      i32.load offset=75120
      local.set 31
      i32.const 1
      local.set 32
      local.get 31
      local.get 32
      i32.add
      local.set 33
      i32.const 0
      local.set 34
      local.get 34
      local.get 33
      i32.store offset=75120
      local.get 6
      local.get 31
      i32.store offset=44
      i32.const 0
      local.set 35
      local.get 6
      local.get 35
      i32.store offset=48
      i32.const 1
      local.set 36
      local.get 6
      local.get 36
      i32.store offset=68
      i32.const 75124
      drop
      i32.const 24
      local.set 37
      i32.const 8
      local.set 38
      local.get 6
      local.get 38
      i32.add
      local.set 39
      local.get 39
      local.get 37
      i32.add
      local.set 40
      i32.const 44
      local.set 41
      local.get 6
      local.get 41
      i32.add
      local.set 42
      local.get 42
      local.get 37
      i32.add
      local.set 43
      local.get 43
      i32.load
      local.set 44
      local.get 40
      local.get 44
      i32.store
      i32.const 16
      local.set 45
      i32.const 8
      local.set 46
      local.get 6
      local.get 46
      i32.add
      local.set 47
      local.get 47
      local.get 45
      i32.add
      local.set 48
      i32.const 44
      local.set 49
      local.get 6
      local.get 49
      i32.add
      local.set 50
      local.get 50
      local.get 45
      i32.add
      local.set 51
      local.get 51
      i64.load align=4
      local.set 52
      local.get 48
      local.get 52
      i64.store
      i32.const 8
      local.set 53
      i32.const 8
      local.set 54
      local.get 6
      local.get 54
      i32.add
      local.set 55
      local.get 55
      local.get 53
      i32.add
      local.set 56
      i32.const 44
      local.set 57
      local.get 6
      local.get 57
      i32.add
      local.set 58
      local.get 58
      local.get 53
      i32.add
      local.set 59
      local.get 59
      i64.load align=4
      local.set 60
      local.get 56
      local.get 60
      i64.store
      local.get 6
      i64.load offset=44 align=4
      local.set 61
      local.get 6
      local.get 61
      i64.store offset=8
      i32.const 75124
      local.set 62
      i32.const 8
      local.set 63
      local.get 6
      local.get 63
      i32.add
      local.set 64
      local.get 62
      local.get 64
      call $add_msg_to_stuff
      local.set 65
      local.get 6
      local.get 65
      i32.store offset=40
      i32.const 0
      local.set 66
      local.get 66
      i32.load offset=75116
      local.set 67
      i32.const 0
      local.set 68
      local.get 68
      i32.load offset=75132
      local.set 69
      local.get 6
      i32.load offset=40
      local.set 70
      i32.const 28
      local.set 71
      local.get 70
      local.get 71
      i32.mul
      local.set 72
      local.get 69
      local.get 72
      i32.add
      local.set 73
      local.get 67
      local.get 73
      call $tryPutMsgCache
      local.set 74
      block  ;; label = @2
        local.get 74
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        local.set 75
        local.get 75
        i32.load offset=75132
        local.set 76
        local.get 6
        i32.load offset=40
        local.set 77
        i32.const 28
        local.set 78
        local.get 77
        local.get 78
        i32.mul
        local.set 79
        local.get 76
        local.get 79
        i32.add
        local.set 80
        i32.const 1
        local.set 81
        local.get 80
        local.get 81
        i32.store offset=4
      end
      local.get 6
      i32.load offset=40
      local.set 82
      local.get 6
      local.get 82
      i32.store offset=92
    end
    local.get 6
    i32.load offset=92
    local.set 83
    i32.const 96
    local.set 84
    local.get 6
    local.get 84
    i32.add
    local.set 85
    local.get 85
    global.set $__stack_pointer
    local.get 83
    return)
  (func $editMsg (type 0) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 4
    i32.const 32
    local.set 5
    local.get 4
    local.get 5
    i32.sub
    local.set 6
    local.get 6
    global.set $__stack_pointer
    local.get 6
    local.get 0
    i32.store offset=24
    local.get 6
    local.get 1
    i32.store offset=20
    local.get 6
    local.get 2
    i32.store offset=16
    local.get 6
    local.get 3
    i32.store offset=12
    local.get 6
    i32.load offset=24
    local.set 7
    i32.const 0
    local.set 8
    local.get 7
    local.get 8
    i32.lt_s
    local.set 9
    i32.const 1
    local.set 10
    local.get 9
    local.get 10
    i32.and
    local.set 11
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 11
          br_if 0 (;@3;)
          local.get 6
          i32.load offset=24
          local.set 12
          i32.const 0
          local.set 13
          local.get 13
          i32.load offset=75136
          local.set 14
          local.get 12
          local.get 14
          i32.ge_s
          local.set 15
          i32.const 1
          local.set 16
          local.get 15
          local.get 16
          i32.and
          local.set 17
          local.get 17
          i32.eqz
          br_if 1 (;@2;)
        end
        i32.const -1
        local.set 18
        local.get 6
        local.get 18
        i32.store offset=28
        br 1 (;@1;)
      end
      local.get 6
      i32.load offset=16
      local.set 19
      i32.const 256
      local.set 20
      local.get 19
      local.get 20
      i32.gt_u
      local.set 21
      i32.const 1
      local.set 22
      local.get 21
      local.get 22
      i32.and
      local.set 23
      block  ;; label = @2
        local.get 23
        i32.eqz
        br_if 0 (;@2;)
        i32.const -1
        local.set 24
        local.get 6
        local.get 24
        i32.store offset=28
        br 1 (;@1;)
      end
      local.get 6
      i32.load offset=16
      local.set 25
      i32.const 1
      local.set 26
      local.get 25
      local.get 26
      i32.add
      local.set 27
      local.get 27
      call $emscripten_builtin_malloc
      local.set 28
      local.get 6
      local.get 28
      i32.store offset=8
      local.get 6
      i32.load offset=8
      local.set 29
      local.get 6
      i32.load offset=16
      local.set 30
      i32.const 1
      local.set 31
      local.get 30
      local.get 31
      i32.add
      local.set 32
      i32.const 0
      local.set 33
      local.get 32
      i32.eqz
      local.set 34
      block  ;; label = @2
        local.get 34
        br_if 0 (;@2;)
        local.get 29
        local.get 33
        local.get 32
        memory.fill
      end
      local.get 6
      i32.load offset=8
      local.set 35
      local.get 6
      i32.load offset=20
      local.set 36
      local.get 6
      i32.load offset=16
      local.set 37
      local.get 35
      local.get 36
      local.get 37
      call $strncpy
      drop
      i32.const 0
      local.set 38
      local.get 38
      i32.load offset=75132
      local.set 39
      local.get 6
      i32.load offset=24
      local.set 40
      i32.const 28
      local.set 41
      local.get 40
      local.get 41
      i32.mul
      local.set 42
      local.get 39
      local.get 42
      i32.add
      local.set 43
      local.get 43
      i32.load offset=8
      local.set 44
      local.get 44
      call $emscripten_builtin_free
      local.get 6
      i32.load offset=8
      local.set 45
      i32.const 0
      local.set 46
      local.get 46
      i32.load offset=75132
      local.set 47
      local.get 6
      i32.load offset=24
      local.set 48
      i32.const 28
      local.set 49
      local.get 48
      local.get 49
      i32.mul
      local.set 50
      local.get 47
      local.get 50
      i32.add
      local.set 51
      local.get 51
      local.get 45
      i32.store offset=8
      local.get 6
      i32.load offset=16
      local.set 52
      i32.const 0
      local.set 53
      local.get 53
      i32.load offset=75132
      local.set 54
      local.get 6
      i32.load offset=24
      local.set 55
      i32.const 28
      local.set 56
      local.get 55
      local.get 56
      i32.mul
      local.set 57
      local.get 54
      local.get 57
      i32.add
      local.set 58
      local.get 58
      local.get 52
      i32.store offset=12
      local.get 6
      i32.load offset=12
      local.set 59
      i32.const 0
      local.set 60
      local.get 60
      i32.load offset=75132
      local.set 61
      local.get 6
      i32.load offset=24
      local.set 62
      i32.const 28
      local.set 63
      local.get 62
      local.get 63
      i32.mul
      local.set 64
      local.get 61
      local.get 64
      i32.add
      local.set 65
      local.get 65
      local.get 59
      i32.store offset=16
      i32.const 0
      local.set 66
      local.get 66
      i32.load offset=75132
      local.set 67
      local.get 6
      i32.load offset=24
      local.set 68
      i32.const 28
      local.set 69
      local.get 68
      local.get 69
      i32.mul
      local.set 70
      local.get 67
      local.get 70
      i32.add
      local.set 71
      i32.const 1
      local.set 72
      local.get 71
      local.get 72
      i32.store offset=20
      i32.const 0
      local.set 73
      local.get 73
      i32.load offset=75132
      local.set 74
      local.get 6
      i32.load offset=24
      local.set 75
      i32.const 28
      local.set 76
      local.get 75
      local.get 76
      i32.mul
      local.set 77
      local.get 74
      local.get 77
      i32.add
      local.set 78
      local.get 78
      i32.load offset=4
      local.set 79
      block  ;; label = @2
        local.get 79
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        local.set 80
        local.get 80
        i32.load offset=75116
        local.set 81
        i32.const 0
        local.set 82
        local.get 82
        i32.load offset=75132
        local.set 83
        local.get 6
        i32.load offset=24
        local.set 84
        i32.const 28
        local.set 85
        local.get 84
        local.get 85
        i32.mul
        local.set 86
        local.get 83
        local.get 86
        i32.add
        local.set 87
        local.get 87
        i32.load
        local.set 88
        local.get 81
        local.get 88
        call $getFromCacheTable
        local.set 89
        local.get 6
        local.get 89
        i32.store offset=4
        local.get 6
        i32.load offset=4
        local.set 90
        i32.const -2
        local.set 91
        local.get 90
        local.get 91
        i32.ne
        local.set 92
        i32.const 1
        local.set 93
        local.get 92
        local.get 93
        i32.and
        local.set 94
        block  ;; label = @3
          local.get 94
          i32.eqz
          br_if 0 (;@3;)
          i32.const 0
          local.set 95
          local.get 95
          i32.load offset=75116
          local.set 96
          i32.const 0
          local.set 97
          local.get 97
          i32.load offset=75132
          local.set 98
          local.get 6
          i32.load offset=24
          local.set 99
          i32.const 28
          local.set 100
          local.get 99
          local.get 100
          i32.mul
          local.set 101
          local.get 98
          local.get 101
          i32.add
          local.set 102
          local.get 6
          i32.load offset=4
          local.set 103
          local.get 96
          local.get 102
          local.get 103
          call $tryUpdateMsgCache
          drop
        end
      end
      i32.const 0
      local.set 104
      local.get 6
      local.get 104
      i32.store offset=28
    end
    local.get 6
    i32.load offset=28
    local.set 105
    i32.const 32
    local.set 106
    local.get 6
    local.get 106
    i32.add
    local.set 107
    local.get 107
    global.set $__stack_pointer
    local.get 105
    return)
  (func $deleteMsg (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i32 i32 i32 i32 i32 i32 i32 i64 i32 i32 i32 i64 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    local.set 2
    i32.const 16
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    i32.store offset=8
    local.get 4
    local.get 1
    i32.store offset=4
    local.get 4
    i32.load offset=8
    local.set 5
    i32.const 0
    local.set 6
    local.get 5
    local.get 6
    i32.lt_s
    local.set 7
    i32.const 1
    local.set 8
    local.get 7
    local.get 8
    i32.and
    local.set 9
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 9
          br_if 0 (;@3;)
          local.get 4
          i32.load offset=8
          local.set 10
          i32.const 0
          local.set 11
          local.get 11
          i32.load offset=75136
          local.set 12
          local.get 10
          local.get 12
          i32.ge_s
          local.set 13
          i32.const 1
          local.set 14
          local.get 13
          local.get 14
          i32.and
          local.set 15
          local.get 15
          i32.eqz
          br_if 1 (;@2;)
        end
        i32.const -1
        local.set 16
        local.get 4
        local.get 16
        i32.store offset=12
        br 1 (;@1;)
      end
      i32.const 0
      local.set 17
      local.get 17
      i32.load offset=75132
      local.set 18
      local.get 4
      i32.load offset=8
      local.set 19
      i32.const 28
      local.set 20
      local.get 19
      local.get 20
      i32.mul
      local.set 21
      local.get 18
      local.get 21
      i32.add
      local.set 22
      local.get 22
      i32.load offset=4
      local.set 23
      block  ;; label = @2
        local.get 23
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        local.set 24
        local.get 24
        i32.load offset=75116
        local.set 25
        i32.const 0
        local.set 26
        local.get 26
        i32.load offset=75132
        local.set 27
        local.get 4
        i32.load offset=8
        local.set 28
        i32.const 28
        local.set 29
        local.get 28
        local.get 29
        i32.mul
        local.set 30
        local.get 27
        local.get 30
        i32.add
        local.set 31
        local.get 31
        i32.load
        local.set 32
        local.get 25
        local.get 32
        call $findnInvalidate
      end
      i32.const 0
      local.set 33
      local.get 33
      i32.load offset=75132
      local.set 34
      local.get 4
      i32.load offset=8
      local.set 35
      i32.const 28
      local.set 36
      local.get 35
      local.get 36
      i32.mul
      local.set 37
      local.get 34
      local.get 37
      i32.add
      local.set 38
      local.get 38
      i32.load offset=8
      local.set 39
      local.get 39
      call $emscripten_builtin_free
      local.get 4
      i32.load offset=8
      local.set 40
      local.get 4
      local.get 40
      i32.store
      block  ;; label = @2
        loop  ;; label = @3
          local.get 4
          i32.load
          local.set 41
          i32.const 0
          local.set 42
          local.get 42
          i32.load offset=75136
          local.set 43
          i32.const 1
          local.set 44
          local.get 43
          local.get 44
          i32.sub
          local.set 45
          local.get 41
          local.get 45
          i32.lt_s
          local.set 46
          i32.const 1
          local.set 47
          local.get 46
          local.get 47
          i32.and
          local.set 48
          local.get 48
          i32.eqz
          br_if 1 (;@2;)
          i32.const 0
          local.set 49
          local.get 49
          i32.load offset=75132
          local.set 50
          local.get 4
          i32.load
          local.set 51
          i32.const 28
          local.set 52
          local.get 51
          local.get 52
          i32.mul
          local.set 53
          local.get 50
          local.get 53
          i32.add
          local.set 54
          i32.const 0
          local.set 55
          local.get 55
          i32.load offset=75132
          local.set 56
          local.get 4
          i32.load
          local.set 57
          i32.const 1
          local.set 58
          local.get 57
          local.get 58
          i32.add
          local.set 59
          i32.const 28
          local.set 60
          local.get 59
          local.get 60
          i32.mul
          local.set 61
          local.get 56
          local.get 61
          i32.add
          local.set 62
          local.get 62
          i64.load align=4
          local.set 63
          local.get 54
          local.get 63
          i64.store align=4
          i32.const 24
          local.set 64
          local.get 54
          local.get 64
          i32.add
          local.set 65
          local.get 62
          local.get 64
          i32.add
          local.set 66
          local.get 66
          i32.load
          local.set 67
          local.get 65
          local.get 67
          i32.store
          i32.const 16
          local.set 68
          local.get 54
          local.get 68
          i32.add
          local.set 69
          local.get 62
          local.get 68
          i32.add
          local.set 70
          local.get 70
          i64.load align=4
          local.set 71
          local.get 69
          local.get 71
          i64.store align=4
          i32.const 8
          local.set 72
          local.get 54
          local.get 72
          i32.add
          local.set 73
          local.get 62
          local.get 72
          i32.add
          local.set 74
          local.get 74
          i64.load align=4
          local.set 75
          local.get 73
          local.get 75
          i64.store align=4
          local.get 4
          i32.load
          local.set 76
          i32.const 1
          local.set 77
          local.get 76
          local.get 77
          i32.add
          local.set 78
          local.get 4
          local.get 78
          i32.store
          br 0 (;@3;)
        end
      end
      i32.const 0
      local.set 79
      local.get 79
      i32.load offset=75136
      local.set 80
      i32.const -1
      local.set 81
      local.get 80
      local.get 81
      i32.add
      local.set 82
      i32.const 0
      local.set 83
      local.get 83
      local.get 82
      i32.store offset=75136
      local.get 4
      i32.load offset=4
      local.set 84
      local.get 4
      i32.load offset=8
      local.set 85
      local.get 85
      local.get 84
      call_indirect (type 1)
      i32.const 0
      local.set 86
      local.get 4
      local.get 86
      i32.store offset=12
    end
    local.get 4
    i32.load offset=12
    local.set 87
    i32.const 16
    local.set 88
    local.get 4
    local.get 88
    i32.add
    local.set 89
    local.get 89
    global.set $__stack_pointer
    local.get 87
    return)
  (func $__math_invalid (type 10) (param f64) (result f64)
    local.get 0
    local.get 0
    f64.sub
    local.tee 0
    local.get 0
    f64.div)
  (func $__math_xflow (type 11) (param i32 f64) (result f64)
    local.get 1
    local.get 1
    f64.neg
    local.get 1
    local.get 0
    select
    call $fp_barrier
    f64.mul)
  (func $fp_barrier (type 10) (param f64) (result f64)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    local.get 0
    f64.store offset=8
    local.get 1
    f64.load offset=8)
  (func $__math_oflow (type 12) (param i32) (result f64)
    local.get 0
    f64.const 0x1p+769 (;=3.10504e+231;)
    call $__math_xflow)
  (func $__math_uflow (type 12) (param i32) (result f64)
    local.get 0
    f64.const 0x1p-767 (;=1.28823e-231;)
    call $__math_xflow)
  (func $fabs (type 10) (param f64) (result f64)
    local.get 0
    f64.abs)
  (func $pow (type 13) (param f64 f64) (result f64)
    (local i32 i32 i32 i32 i32 i64 i64 i32 f64 i64 f64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 0
    call $top12
    local.set 3
    local.get 1
    call $top12
    local.tee 4
    i32.const 2047
    i32.and
    local.tee 5
    i32.const -1086
    i32.add
    local.set 6
    local.get 1
    i64.reinterpret_f64
    local.set 7
    local.get 0
    i64.reinterpret_f64
    local.set 8
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const -2047
          i32.add
          i32.const -2046
          i32.lt_u
          br_if 0 (;@3;)
          i32.const 0
          local.set 9
          local.get 6
          i32.const -129
          i32.gt_u
          br_if 1 (;@2;)
        end
        block  ;; label = @3
          local.get 7
          call $zeroinfnan
          i32.eqz
          br_if 0 (;@3;)
          f64.const 0x1p+0 (;=1;)
          local.set 10
          local.get 8
          i64.const 4607182418800017408
          i64.eq
          br_if 2 (;@1;)
          local.get 7
          i64.const 1
          i64.shl
          local.tee 11
          i64.eqz
          br_if 2 (;@1;)
          block  ;; label = @4
            block  ;; label = @5
              local.get 8
              i64.const 1
              i64.shl
              local.tee 8
              i64.const -9007199254740992
              i64.gt_u
              br_if 0 (;@5;)
              local.get 11
              i64.const -9007199254740991
              i64.lt_u
              br_if 1 (;@4;)
            end
            local.get 0
            local.get 1
            f64.add
            local.set 10
            br 3 (;@1;)
          end
          local.get 8
          i64.const 9214364837600034816
          i64.eq
          br_if 2 (;@1;)
          f64.const 0x0p+0 (;=0;)
          local.get 1
          local.get 1
          f64.mul
          local.get 8
          i64.const 9214364837600034816
          i64.lt_u
          local.get 7
          i64.const 0
          i64.lt_s
          i32.xor
          select
          local.set 10
          br 2 (;@1;)
        end
        block  ;; label = @3
          local.get 8
          call $zeroinfnan
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          local.get 0
          f64.mul
          local.set 10
          block  ;; label = @4
            local.get 8
            i64.const -1
            i64.gt_s
            br_if 0 (;@4;)
            local.get 10
            f64.neg
            local.get 10
            local.get 7
            call $checkint
            i32.const 1
            i32.eq
            select
            local.set 10
          end
          local.get 7
          i64.const -1
          i64.gt_s
          br_if 2 (;@1;)
          f64.const 0x1p+0 (;=1;)
          local.get 10
          f64.div
          call $fp_barrier.1
          local.set 10
          br 2 (;@1;)
        end
        i32.const 0
        local.set 9
        block  ;; label = @3
          local.get 8
          i64.const -1
          i64.gt_s
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 7
            call $checkint
            local.tee 9
            br_if 0 (;@4;)
            local.get 0
            call $__math_invalid
            local.set 10
            br 3 (;@1;)
          end
          i32.const 262144
          i32.const 0
          local.get 9
          i32.const 1
          i32.eq
          select
          local.set 9
          local.get 3
          i32.const 2047
          i32.and
          local.set 3
          local.get 0
          i64.reinterpret_f64
          i64.const 9223372036854775807
          i64.and
          local.set 8
        end
        block  ;; label = @3
          local.get 6
          i32.const -129
          i32.gt_u
          br_if 0 (;@3;)
          f64.const 0x1p+0 (;=1;)
          local.set 10
          local.get 8
          i64.const 4607182418800017408
          i64.eq
          br_if 2 (;@1;)
          block  ;; label = @4
            local.get 5
            i32.const 957
            i32.gt_u
            br_if 0 (;@4;)
            local.get 1
            local.get 1
            f64.neg
            local.get 8
            i64.const 4607182418800017408
            i64.gt_u
            select
            f64.const 0x1p+0 (;=1;)
            f64.add
            local.set 10
            br 3 (;@1;)
          end
          block  ;; label = @4
            local.get 4
            i32.const 2047
            i32.gt_u
            local.get 8
            i64.const 4607182418800017408
            i64.gt_u
            i32.eq
            br_if 0 (;@4;)
            i32.const 0
            call $__math_oflow
            local.set 10
            br 3 (;@1;)
          end
          i32.const 0
          call $__math_uflow
          local.set 10
          br 2 (;@1;)
        end
        local.get 3
        br_if 0 (;@2;)
        local.get 0
        f64.const 0x1p+52 (;=4.5036e+15;)
        f64.mul
        i64.reinterpret_f64
        i64.const 9223372036854775807
        i64.and
        i64.const -234187180623265792
        i64.add
        local.set 8
      end
      local.get 7
      i64.const -134217728
      i64.and
      f64.reinterpret_i64
      local.tee 10
      local.get 8
      local.get 2
      i32.const 8
      i32.add
      call $log_inline
      local.tee 12
      i64.reinterpret_f64
      i64.const -134217728
      i64.and
      f64.reinterpret_i64
      local.tee 0
      f64.mul
      local.get 1
      local.get 10
      f64.sub
      local.get 0
      f64.mul
      local.get 1
      local.get 2
      f64.load offset=8
      local.get 12
      local.get 0
      f64.sub
      f64.add
      f64.mul
      f64.add
      local.get 9
      call $exp_inline
      local.set 10
    end
    local.get 2
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 10)
  (func $top12 (type 14) (param f64) (result i32)
    local.get 0
    i64.reinterpret_f64
    i64.const 52
    i64.shr_u
    i32.wrap_i64)
  (func $zeroinfnan (type 15) (param i64) (result i32)
    local.get 0
    i64.const 1
    i64.shl
    i64.const 9007199254740992
    i64.add
    i64.const 9007199254740993
    i64.lt_u)
  (func $checkint (type 15) (param i64) (result i32)
    (local i32 i32 i64)
    i32.const 0
    local.set 1
    block  ;; label = @1
      local.get 0
      i64.const 52
      i64.shr_u
      i32.wrap_i64
      i32.const 2047
      i32.and
      local.tee 2
      i32.const 1023
      i32.lt_u
      br_if 0 (;@1;)
      i32.const 2
      local.set 1
      local.get 2
      i32.const 1075
      i32.gt_u
      br_if 0 (;@1;)
      i32.const 0
      local.set 1
      i64.const 1
      i32.const 1075
      local.get 2
      i32.sub
      i64.extend_i32_u
      i64.shl
      local.tee 3
      i64.const -1
      i64.add
      local.get 0
      i64.and
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
      i32.const 2
      i32.const 1
      local.get 3
      local.get 0
      i64.and
      i64.eqz
      select
      local.set 1
    end
    local.get 1)
  (func $fp_barrier.1 (type 10) (param f64) (result f64)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    local.get 0
    f64.store offset=8
    local.get 1
    f64.load offset=8)
  (func $log_inline (type 16) (param i64 i32) (result f64)
    (local i64 f64 i32 f64 f64 f64 f64 f64)
    local.get 1
    local.get 0
    i64.const -4604531861337669632
    i64.add
    local.tee 2
    i64.const 52
    i64.shr_s
    i32.wrap_i64
    f64.convert_i32_s
    local.tee 3
    i32.const 0
    f64.load offset=67824
    f64.mul
    local.get 2
    i64.const 45
    i64.shr_u
    i32.wrap_i64
    i32.const 127
    i32.and
    i32.const 5
    i32.shl
    local.tee 4
    i32.const 67912
    i32.add
    f64.load
    f64.add
    local.get 0
    local.get 2
    i64.const -4503599627370496
    i64.and
    i64.sub
    local.tee 0
    i64.const 2147483648
    i64.add
    i64.const -4294967296
    i64.and
    f64.reinterpret_i64
    local.tee 5
    local.get 4
    i32.const 67888
    i32.add
    f64.load
    local.tee 6
    f64.mul
    f64.const -0x1p+0 (;=-1;)
    f64.add
    local.tee 7
    local.get 0
    f64.reinterpret_i64
    local.get 5
    f64.sub
    local.get 6
    f64.mul
    local.tee 6
    f64.add
    local.tee 5
    local.get 3
    i32.const 0
    f64.load offset=67816
    f64.mul
    local.get 4
    i32.const 67904
    i32.add
    f64.load
    f64.add
    local.tee 3
    local.get 5
    local.get 3
    f64.add
    local.tee 3
    f64.sub
    f64.add
    f64.add
    local.get 6
    local.get 5
    i32.const 0
    f64.load offset=67832
    local.tee 8
    f64.mul
    local.tee 9
    local.get 7
    local.get 8
    f64.mul
    local.tee 8
    f64.add
    f64.mul
    f64.add
    local.get 7
    local.get 8
    f64.mul
    local.tee 7
    local.get 3
    local.get 3
    local.get 7
    f64.add
    local.tee 7
    f64.sub
    f64.add
    f64.add
    local.get 5
    local.get 5
    local.get 9
    f64.mul
    local.tee 3
    f64.mul
    local.get 3
    local.get 3
    local.get 5
    i32.const 0
    f64.load offset=67880
    f64.mul
    i32.const 0
    f64.load offset=67872
    f64.add
    f64.mul
    local.get 5
    i32.const 0
    f64.load offset=67864
    f64.mul
    i32.const 0
    f64.load offset=67856
    f64.add
    f64.add
    f64.mul
    local.get 5
    i32.const 0
    f64.load offset=67848
    f64.mul
    i32.const 0
    f64.load offset=67840
    f64.add
    f64.add
    f64.mul
    f64.add
    local.tee 5
    local.get 7
    local.get 7
    local.get 5
    f64.add
    local.tee 5
    f64.sub
    f64.add
    f64.store
    local.get 5)
  (func $exp_inline (type 17) (param f64 f64 i32) (result f64)
    (local i32 i32 f64 f64 i64 i64)
    block  ;; label = @1
      local.get 0
      call $top12
      i32.const 2047
      i32.and
      local.tee 3
      f64.const 0x1p-54 (;=5.55112e-17;)
      call $top12
      local.tee 4
      i32.sub
      f64.const 0x1p+9 (;=512;)
      call $top12
      local.get 4
      i32.sub
      i32.lt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 3
        local.get 4
        i32.ge_u
        br_if 0 (;@2;)
        local.get 0
        f64.const 0x1p+0 (;=1;)
        f64.add
        local.tee 0
        f64.neg
        local.get 0
        local.get 2
        select
        return
      end
      local.get 3
      f64.const 0x1p+10 (;=1024;)
      call $top12
      i32.lt_u
      local.set 4
      i32.const 0
      local.set 3
      local.get 4
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 0
        i64.reinterpret_f64
        i64.const -1
        i64.gt_s
        br_if 0 (;@2;)
        local.get 2
        call $__math_uflow
        return
      end
      local.get 2
      call $__math_oflow
      return
    end
    local.get 1
    local.get 0
    i32.const 0
    f64.load offset=65656
    f64.mul
    i32.const 0
    f64.load offset=65664
    local.tee 5
    f64.add
    local.tee 6
    local.get 5
    f64.sub
    local.tee 5
    i32.const 0
    f64.load offset=65680
    f64.mul
    local.get 5
    i32.const 0
    f64.load offset=65672
    f64.mul
    local.get 0
    f64.add
    f64.add
    f64.add
    local.tee 0
    local.get 0
    f64.mul
    local.tee 1
    local.get 1
    f64.mul
    local.get 0
    i32.const 0
    f64.load offset=65712
    f64.mul
    i32.const 0
    f64.load offset=65704
    f64.add
    f64.mul
    local.get 1
    local.get 0
    i32.const 0
    f64.load offset=65696
    f64.mul
    i32.const 0
    f64.load offset=65688
    f64.add
    f64.mul
    local.get 6
    i64.reinterpret_f64
    local.tee 7
    i32.wrap_i64
    i32.const 4
    i32.shl
    i32.const 2032
    i32.and
    local.tee 4
    i32.const 65768
    i32.add
    f64.load
    local.get 0
    f64.add
    f64.add
    f64.add
    local.set 0
    local.get 4
    i32.const 65776
    i32.add
    i64.load
    local.get 7
    local.get 2
    i64.extend_i32_u
    i64.add
    i64.const 45
    i64.shl
    i64.add
    local.set 8
    block  ;; label = @1
      local.get 3
      br_if 0 (;@1;)
      local.get 0
      local.get 8
      local.get 7
      call $specialcase
      return
    end
    local.get 8
    f64.reinterpret_i64
    local.tee 1
    local.get 0
    f64.mul
    local.get 1
    f64.add)
  (func $specialcase (type 18) (param f64 i64 i64) (result f64)
    (local f64 f64 f64 f64)
    block  ;; label = @1
      local.get 2
      i64.const 2147483648
      i64.and
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
      local.get 1
      i64.const -4544132024016830464
      i64.add
      f64.reinterpret_i64
      local.tee 3
      local.get 0
      f64.mul
      local.get 3
      f64.add
      f64.const 0x1p+1009 (;=5.48612e+303;)
      f64.mul
      return
    end
    block  ;; label = @1
      local.get 1
      i64.const 4602678819172646912
      i64.add
      local.tee 2
      f64.reinterpret_i64
      local.tee 3
      local.get 0
      f64.mul
      local.tee 4
      local.get 3
      f64.add
      local.tee 0
      call $fabs
      f64.const 0x1p+0 (;=1;)
      f64.lt
      i32.eqz
      br_if 0 (;@1;)
      f64.const 0x1p-1022 (;=2.22507e-308;)
      call $fp_barrier.1
      f64.const 0x1p-1022 (;=2.22507e-308;)
      f64.mul
      call $fp_force_eval
      local.get 2
      i64.const -9223372036854775808
      i64.and
      f64.reinterpret_i64
      local.get 0
      f64.const -0x1p+0 (;=-1;)
      f64.const 0x1p+0 (;=1;)
      local.get 0
      f64.const 0x0p+0 (;=0;)
      f64.lt
      select
      local.tee 5
      f64.add
      local.tee 6
      local.get 4
      local.get 3
      local.get 0
      f64.sub
      f64.add
      local.get 0
      local.get 5
      local.get 6
      f64.sub
      f64.add
      f64.add
      f64.add
      local.get 5
      f64.sub
      local.tee 0
      local.get 0
      f64.const 0x0p+0 (;=0;)
      f64.eq
      select
      local.set 0
    end
    local.get 0
    f64.const 0x1p-1022 (;=2.22507e-308;)
    f64.mul)
  (func $fp_force_eval (type 19) (param f64)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.get 0
    f64.store offset=8)
  (func $snprintf (type 0) (param i32 i32 i32 i32) (result i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 4
    global.set $__stack_pointer
    local.get 4
    local.get 3
    i32.store offset=12
    local.get 0
    local.get 1
    local.get 2
    local.get 3
    call $vsnprintf
    local.set 3
    local.get 4
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 3)
  (func $__memset (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i64)
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.store8
      local.get 0
      local.get 2
      i32.add
      local.tee 3
      i32.const -1
      i32.add
      local.get 1
      i32.store8
      local.get 2
      i32.const 3
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.store8 offset=2
      local.get 0
      local.get 1
      i32.store8 offset=1
      local.get 3
      i32.const -3
      i32.add
      local.get 1
      i32.store8
      local.get 3
      i32.const -2
      i32.add
      local.get 1
      i32.store8
      local.get 2
      i32.const 7
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.store8 offset=3
      local.get 3
      i32.const -4
      i32.add
      local.get 1
      i32.store8
      local.get 2
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      local.get 0
      i32.sub
      i32.const 3
      i32.and
      local.tee 4
      i32.add
      local.tee 3
      local.get 1
      i32.const 255
      i32.and
      i32.const 16843009
      i32.mul
      local.tee 1
      i32.store
      local.get 3
      local.get 2
      local.get 4
      i32.sub
      i32.const -4
      i32.and
      local.tee 4
      i32.add
      local.tee 2
      i32.const -4
      i32.add
      local.get 1
      i32.store
      local.get 4
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      local.get 3
      local.get 1
      i32.store offset=8
      local.get 3
      local.get 1
      i32.store offset=4
      local.get 2
      i32.const -8
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -12
      i32.add
      local.get 1
      i32.store
      local.get 4
      i32.const 25
      i32.lt_u
      br_if 0 (;@1;)
      local.get 3
      local.get 1
      i32.store offset=24
      local.get 3
      local.get 1
      i32.store offset=20
      local.get 3
      local.get 1
      i32.store offset=16
      local.get 3
      local.get 1
      i32.store offset=12
      local.get 2
      i32.const -16
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -20
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -24
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -28
      i32.add
      local.get 1
      i32.store
      local.get 4
      local.get 3
      i32.const 4
      i32.and
      i32.const 24
      i32.or
      local.tee 5
      i32.sub
      local.tee 2
      i32.const 32
      i32.lt_u
      br_if 0 (;@1;)
      local.get 1
      i64.extend_i32_u
      i64.const 4294967297
      i64.mul
      local.set 6
      local.get 3
      local.get 5
      i32.add
      local.set 1
      loop  ;; label = @2
        local.get 1
        local.get 6
        i64.store offset=24
        local.get 1
        local.get 6
        i64.store offset=16
        local.get 1
        local.get 6
        i64.store offset=8
        local.get 1
        local.get 6
        i64.store
        local.get 1
        i32.const 32
        i32.add
        local.set 1
        local.get 2
        i32.const -32
        i32.add
        local.tee 2
        i32.const 31
        i32.gt_u
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $__stpncpy (type 2) (param i32 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            local.get 0
            i32.xor
            i32.const 3
            i32.and
            br_if 0 (;@4;)
            local.get 2
            i32.const 0
            i32.ne
            local.set 3
            block  ;; label = @5
              local.get 1
              i32.const 3
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              local.get 2
              i32.eqz
              br_if 0 (;@5;)
              loop  ;; label = @6
                local.get 0
                local.get 1
                i32.load8_u
                local.tee 3
                i32.store8
                local.get 3
                i32.eqz
                br_if 5 (;@1;)
                local.get 0
                i32.const 1
                i32.add
                local.set 0
                local.get 2
                i32.const -1
                i32.add
                local.tee 2
                i32.const 0
                i32.ne
                local.set 3
                local.get 1
                i32.const 1
                i32.add
                local.tee 1
                i32.const 3
                i32.and
                i32.eqz
                br_if 1 (;@5;)
                local.get 2
                br_if 0 (;@6;)
              end
            end
            local.get 3
            i32.eqz
            br_if 2 (;@2;)
            local.get 1
            i32.load8_u
            i32.eqz
            br_if 3 (;@1;)
            local.get 2
            i32.const 4
            i32.lt_u
            br_if 0 (;@4;)
            loop  ;; label = @5
              i32.const 16843008
              local.get 1
              i32.load
              local.tee 3
              i32.sub
              local.get 3
              i32.or
              i32.const -2139062144
              i32.and
              i32.const -2139062144
              i32.ne
              br_if 2 (;@3;)
              local.get 0
              local.get 3
              i32.store
              local.get 0
              i32.const 4
              i32.add
              local.set 0
              local.get 1
              i32.const 4
              i32.add
              local.set 1
              local.get 2
              i32.const -4
              i32.add
              local.tee 2
              i32.const 3
              i32.gt_u
              br_if 0 (;@5;)
            end
          end
          local.get 2
          i32.eqz
          br_if 1 (;@2;)
        end
        loop  ;; label = @3
          local.get 0
          local.get 1
          i32.load8_u
          local.tee 3
          i32.store8
          local.get 3
          i32.eqz
          br_if 2 (;@1;)
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 2
          i32.const -1
          i32.add
          local.tee 2
          br_if 0 (;@3;)
        end
      end
      i32.const 0
      local.set 2
    end
    local.get 0
    i32.const 0
    local.get 2
    call $__memset
    drop
    local.get 0)
  (func $strncpy (type 2) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $__stpncpy
    drop
    local.get 0)
  (func $__lockfile (type 8) (param i32) (result i32)
    i32.const 1)
  (func $__unlockfile (type 1) (param i32))
  (func $__lock (type 1) (param i32))
  (func $__unlock (type 1) (param i32))
  (func $__ofl_lock (type 20) (result i32)
    i32.const 75144
    call $__lock
    i32.const 75148)
  (func $__ofl_unlock (type 7)
    i32.const 75144
    call $__unlock)
  (func $__towrite (type 8) (param i32) (result i32)
    (local i32)
    local.get 0
    local.get 0
    i32.load offset=72
    local.tee 1
    i32.const -1
    i32.add
    local.get 1
    i32.or
    i32.store offset=72
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 1
      i32.const 8
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.const 32
      i32.or
      i32.store
      i32.const -1
      return
    end
    local.get 0
    i64.const 0
    i64.store offset=4 align=4
    local.get 0
    local.get 0
    i32.load offset=44
    local.tee 1
    i32.store offset=28
    local.get 0
    local.get 1
    i32.store offset=20
    local.get 0
    local.get 1
    local.get 0
    i32.load offset=48
    i32.add
    i32.store offset=16
    i32.const 0)
  (func $memchr (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32)
    local.get 2
    i32.const 0
    i32.ne
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 3
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          i32.const 255
          i32.and
          local.set 4
          loop  ;; label = @4
            local.get 0
            i32.load8_u
            local.get 4
            i32.eq
            br_if 2 (;@2;)
            local.get 2
            i32.const -1
            i32.add
            local.tee 2
            i32.const 0
            i32.ne
            local.set 3
            local.get 0
            i32.const 1
            i32.add
            local.tee 0
            i32.const 3
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            local.get 2
            br_if 0 (;@4;)
          end
        end
        local.get 3
        i32.eqz
        br_if 1 (;@1;)
        block  ;; label = @3
          local.get 0
          i32.load8_u
          local.get 1
          i32.const 255
          i32.and
          i32.eq
          br_if 0 (;@3;)
          local.get 2
          i32.const 4
          i32.lt_u
          br_if 0 (;@3;)
          local.get 1
          i32.const 255
          i32.and
          i32.const 16843009
          i32.mul
          local.set 4
          loop  ;; label = @4
            i32.const 16843008
            local.get 0
            i32.load
            local.get 4
            i32.xor
            local.tee 3
            i32.sub
            local.get 3
            i32.or
            i32.const -2139062144
            i32.and
            i32.const -2139062144
            i32.ne
            br_if 2 (;@2;)
            local.get 0
            i32.const 4
            i32.add
            local.set 0
            local.get 2
            i32.const -4
            i32.add
            local.tee 2
            i32.const 3
            i32.gt_u
            br_if 0 (;@4;)
          end
        end
        local.get 2
        i32.eqz
        br_if 1 (;@1;)
      end
      local.get 1
      i32.const 255
      i32.and
      local.set 3
      loop  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u
          local.get 3
          i32.ne
          br_if 0 (;@3;)
          local.get 0
          return
        end
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    i32.const 0)
  (func $strnlen (type 6) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    i32.const 0
    local.get 1
    call $memchr
    local.tee 2
    local.get 0
    i32.sub
    local.get 1
    local.get 2
    select)
  (func $__errno_location (type 20) (result i32)
    i32.const 75156)
  (func $frexp (type 21) (param f64 i32) (result f64)
    (local i64 i32)
    block  ;; label = @1
      local.get 0
      i64.reinterpret_f64
      local.tee 2
      i64.const 52
      i64.shr_u
      i32.wrap_i64
      i32.const 2047
      i32.and
      local.tee 3
      i32.const 2047
      i32.eq
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 3
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            f64.const 0x0p+0 (;=0;)
            f64.ne
            br_if 0 (;@4;)
            i32.const 0
            local.set 3
            br 1 (;@3;)
          end
          local.get 0
          f64.const 0x1p+64 (;=1.84467e+19;)
          f64.mul
          local.get 1
          call $frexp
          local.set 0
          local.get 1
          i32.load
          i32.const -64
          i32.add
          local.set 3
        end
        local.get 1
        local.get 3
        i32.store
        local.get 0
        return
      end
      local.get 1
      local.get 3
      i32.const -1022
      i32.add
      i32.store
      local.get 2
      i64.const -9218868437227405313
      i64.and
      i64.const 4602678819172646912
      i64.or
      f64.reinterpret_i64
      local.set 0
    end
    local.get 0)
  (func $_emscripten_memcpy_bulkmem (type 2) (param i32 i32 i32) (result i32)
    local.get 2
    if  ;; label = @1
      local.get 0
      local.get 1
      local.get 2
      memory.copy
    end
    local.get 0)
  (func $__memcpy (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 2
      i32.const 512
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      local.get 2
      call $_emscripten_memcpy_bulkmem
      return
    end
    local.get 0
    local.get 2
    i32.add
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        local.get 0
        i32.xor
        i32.const 3
        i32.and
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.const 3
            i32.and
            br_if 0 (;@4;)
            local.get 0
            local.set 2
            br 1 (;@3;)
          end
          block  ;; label = @4
            local.get 2
            br_if 0 (;@4;)
            local.get 0
            local.set 2
            br 1 (;@3;)
          end
          local.get 0
          local.set 2
          loop  ;; label = @4
            local.get 2
            local.get 1
            i32.load8_u
            i32.store8
            local.get 1
            i32.const 1
            i32.add
            local.set 1
            local.get 2
            i32.const 1
            i32.add
            local.tee 2
            i32.const 3
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            local.get 2
            local.get 3
            i32.lt_u
            br_if 0 (;@4;)
          end
        end
        local.get 3
        i32.const -4
        i32.and
        local.set 4
        block  ;; label = @3
          local.get 3
          i32.const 64
          i32.lt_u
          br_if 0 (;@3;)
          local.get 2
          local.get 4
          i32.const -64
          i32.add
          local.tee 5
          i32.gt_u
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 2
            local.get 1
            i32.load
            i32.store
            local.get 2
            local.get 1
            i32.load offset=4
            i32.store offset=4
            local.get 2
            local.get 1
            i32.load offset=8
            i32.store offset=8
            local.get 2
            local.get 1
            i32.load offset=12
            i32.store offset=12
            local.get 2
            local.get 1
            i32.load offset=16
            i32.store offset=16
            local.get 2
            local.get 1
            i32.load offset=20
            i32.store offset=20
            local.get 2
            local.get 1
            i32.load offset=24
            i32.store offset=24
            local.get 2
            local.get 1
            i32.load offset=28
            i32.store offset=28
            local.get 2
            local.get 1
            i32.load offset=32
            i32.store offset=32
            local.get 2
            local.get 1
            i32.load offset=36
            i32.store offset=36
            local.get 2
            local.get 1
            i32.load offset=40
            i32.store offset=40
            local.get 2
            local.get 1
            i32.load offset=44
            i32.store offset=44
            local.get 2
            local.get 1
            i32.load offset=48
            i32.store offset=48
            local.get 2
            local.get 1
            i32.load offset=52
            i32.store offset=52
            local.get 2
            local.get 1
            i32.load offset=56
            i32.store offset=56
            local.get 2
            local.get 1
            i32.load offset=60
            i32.store offset=60
            local.get 1
            i32.const 64
            i32.add
            local.set 1
            local.get 2
            i32.const 64
            i32.add
            local.tee 2
            local.get 5
            i32.le_u
            br_if 0 (;@4;)
          end
        end
        local.get 2
        local.get 4
        i32.ge_u
        br_if 1 (;@1;)
        loop  ;; label = @3
          local.get 2
          local.get 1
          i32.load
          i32.store
          local.get 1
          i32.const 4
          i32.add
          local.set 1
          local.get 2
          i32.const 4
          i32.add
          local.tee 2
          local.get 4
          i32.lt_u
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      block  ;; label = @2
        local.get 3
        i32.const 4
        i32.ge_u
        br_if 0 (;@2;)
        local.get 0
        local.set 2
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        local.get 3
        i32.const -4
        i32.add
        local.tee 4
        i32.le_u
        br_if 0 (;@2;)
        local.get 0
        local.set 2
        br 1 (;@1;)
      end
      local.get 0
      local.set 2
      loop  ;; label = @2
        local.get 2
        local.get 1
        i32.load8_u
        i32.store8
        local.get 2
        local.get 1
        i32.load8_u offset=1
        i32.store8 offset=1
        local.get 2
        local.get 1
        i32.load8_u offset=2
        i32.store8 offset=2
        local.get 2
        local.get 1
        i32.load8_u offset=3
        i32.store8 offset=3
        local.get 1
        i32.const 4
        i32.add
        local.set 1
        local.get 2
        i32.const 4
        i32.add
        local.tee 2
        local.get 4
        i32.le_u
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      local.get 3
      i32.ge_u
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 2
        local.get 1
        i32.load8_u
        i32.store8
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 2
        i32.const 1
        i32.add
        local.tee 2
        local.get 3
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $__fwritex (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=16
        local.tee 3
        br_if 0 (;@2;)
        i32.const 0
        local.set 4
        local.get 2
        call $__towrite
        br_if 1 (;@1;)
        local.get 2
        i32.load offset=16
        local.set 3
      end
      block  ;; label = @2
        local.get 1
        local.get 3
        local.get 2
        i32.load offset=20
        local.tee 4
        i32.sub
        i32.le_u
        br_if 0 (;@2;)
        local.get 2
        local.get 0
        local.get 1
        local.get 2
        i32.load offset=36
        call_indirect (type 2)
        return
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.load offset=80
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          local.get 1
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          local.set 3
          block  ;; label = @4
            loop  ;; label = @5
              local.get 0
              local.get 3
              i32.add
              local.tee 5
              i32.const -1
              i32.add
              i32.load8_u
              i32.const 10
              i32.eq
              br_if 1 (;@4;)
              local.get 3
              i32.const -1
              i32.add
              local.tee 3
              i32.eqz
              br_if 2 (;@3;)
              br 0 (;@5;)
            end
          end
          local.get 2
          local.get 0
          local.get 3
          local.get 2
          i32.load offset=36
          call_indirect (type 2)
          local.tee 4
          local.get 3
          i32.lt_u
          br_if 2 (;@1;)
          local.get 1
          local.get 3
          i32.sub
          local.set 1
          local.get 2
          i32.load offset=20
          local.set 4
          br 1 (;@2;)
        end
        local.get 0
        local.set 5
        i32.const 0
        local.set 3
      end
      local.get 4
      local.get 5
      local.get 1
      call $__memcpy
      drop
      local.get 2
      local.get 2
      i32.load offset=20
      local.get 1
      i32.add
      i32.store offset=20
      local.get 3
      local.get 1
      i32.add
      local.set 4
    end
    local.get 4)
  (func $__vfprintf_internal (type 22) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 208
    i32.sub
    local.tee 5
    global.set $__stack_pointer
    local.get 5
    local.get 2
    i32.store offset=204
    block  ;; label = @1
      i32.const 40
      i32.eqz
      br_if 0 (;@1;)
      local.get 5
      i32.const 160
      i32.add
      i32.const 0
      i32.const 40
      memory.fill
    end
    local.get 5
    local.get 5
    i32.load offset=204
    i32.store offset=200
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        local.get 1
        local.get 5
        i32.const 200
        i32.add
        local.get 5
        i32.const 80
        i32.add
        local.get 5
        i32.const 160
        i32.add
        local.get 3
        local.get 4
        call $printf_core
        i32.const 0
        i32.ge_s
        br_if 0 (;@2;)
        i32.const -1
        local.set 4
        br 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load offset=76
          i32.const 0
          i32.ge_s
          br_if 0 (;@3;)
          i32.const 1
          local.set 6
          br 1 (;@2;)
        end
        local.get 0
        call $__lockfile
        i32.eqz
        local.set 6
      end
      local.get 0
      local.get 0
      i32.load
      local.tee 7
      i32.const -33
      i32.and
      i32.store
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.load offset=48
              br_if 0 (;@5;)
              local.get 0
              i32.const 80
              i32.store offset=48
              local.get 0
              i32.const 0
              i32.store offset=28
              local.get 0
              i64.const 0
              i64.store offset=16
              local.get 0
              i32.load offset=44
              local.set 8
              local.get 0
              local.get 5
              i32.store offset=44
              br 1 (;@4;)
            end
            i32.const 0
            local.set 8
            local.get 0
            i32.load offset=16
            br_if 1 (;@3;)
          end
          i32.const -1
          local.set 2
          local.get 0
          call $__towrite
          br_if 1 (;@2;)
        end
        local.get 0
        local.get 1
        local.get 5
        i32.const 200
        i32.add
        local.get 5
        i32.const 80
        i32.add
        local.get 5
        i32.const 160
        i32.add
        local.get 3
        local.get 4
        call $printf_core
        local.set 2
      end
      local.get 7
      i32.const 32
      i32.and
      local.set 4
      block  ;; label = @2
        local.get 8
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 0
        i32.const 0
        local.get 0
        i32.load offset=36
        call_indirect (type 2)
        drop
        local.get 0
        i32.const 0
        i32.store offset=48
        local.get 0
        local.get 8
        i32.store offset=44
        local.get 0
        i32.const 0
        i32.store offset=28
        local.get 0
        i32.load offset=20
        local.set 3
        local.get 0
        i64.const 0
        i64.store offset=16
        local.get 2
        i32.const -1
        local.get 3
        select
        local.set 2
      end
      local.get 0
      local.get 0
      i32.load
      local.tee 3
      local.get 4
      i32.or
      i32.store
      i32.const -1
      local.get 2
      local.get 3
      i32.const 32
      i32.and
      select
      local.set 4
      local.get 6
      br_if 0 (;@1;)
      local.get 0
      call $__unlockfile
    end
    local.get 5
    i32.const 208
    i32.add
    global.set $__stack_pointer
    local.get 4)
  (func $printf_core (type 23) (param i32 i32 i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64)
    global.get $__stack_pointer
    i32.const 64
    i32.sub
    local.tee 7
    global.set $__stack_pointer
    local.get 7
    local.get 1
    i32.store offset=60
    local.get 7
    i32.const 39
    i32.add
    local.set 8
    local.get 7
    i32.const 40
    i32.add
    local.set 9
    i32.const 0
    local.set 10
    i32.const 0
    local.set 11
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            loop  ;; label = @5
              i32.const 0
              local.set 12
              loop  ;; label = @6
                local.get 1
                local.set 13
                local.get 12
                local.get 11
                i32.const 2147483647
                i32.xor
                i32.gt_s
                br_if 2 (;@4;)
                local.get 12
                local.get 11
                i32.add
                local.set 11
                local.get 13
                local.set 12
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            local.get 13
                            i32.load8_u
                            local.tee 14
                            i32.eqz
                            br_if 0 (;@12;)
                            loop  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    local.get 14
                                    i32.const 255
                                    i32.and
                                    local.tee 14
                                    br_if 0 (;@16;)
                                    local.get 12
                                    local.set 1
                                    br 1 (;@15;)
                                  end
                                  local.get 14
                                  i32.const 37
                                  i32.ne
                                  br_if 1 (;@14;)
                                  local.get 12
                                  local.set 14
                                  loop  ;; label = @16
                                    block  ;; label = @17
                                      local.get 14
                                      i32.load8_u offset=1
                                      i32.const 37
                                      i32.eq
                                      br_if 0 (;@17;)
                                      local.get 14
                                      local.set 1
                                      br 2 (;@15;)
                                    end
                                    local.get 12
                                    i32.const 1
                                    i32.add
                                    local.set 12
                                    local.get 14
                                    i32.load8_u offset=2
                                    local.set 15
                                    local.get 14
                                    i32.const 2
                                    i32.add
                                    local.tee 1
                                    local.set 14
                                    local.get 15
                                    i32.const 37
                                    i32.eq
                                    br_if 0 (;@16;)
                                  end
                                end
                                local.get 12
                                local.get 13
                                i32.sub
                                local.tee 12
                                local.get 11
                                i32.const 2147483647
                                i32.xor
                                local.tee 14
                                i32.gt_s
                                br_if 10 (;@4;)
                                block  ;; label = @15
                                  local.get 0
                                  i32.eqz
                                  br_if 0 (;@15;)
                                  local.get 0
                                  local.get 13
                                  local.get 12
                                  call $out
                                end
                                local.get 12
                                br_if 8 (;@6;)
                                local.get 7
                                local.get 1
                                i32.store offset=60
                                local.get 1
                                i32.const 1
                                i32.add
                                local.set 12
                                i32.const -1
                                local.set 16
                                block  ;; label = @15
                                  local.get 1
                                  i32.load8_s offset=1
                                  i32.const -48
                                  i32.add
                                  local.tee 15
                                  i32.const 9
                                  i32.gt_u
                                  br_if 0 (;@15;)
                                  local.get 1
                                  i32.load8_u offset=2
                                  i32.const 36
                                  i32.ne
                                  br_if 0 (;@15;)
                                  local.get 1
                                  i32.const 3
                                  i32.add
                                  local.set 12
                                  i32.const 1
                                  local.set 10
                                  local.get 15
                                  local.set 16
                                end
                                local.get 7
                                local.get 12
                                i32.store offset=60
                                i32.const 0
                                local.set 17
                                block  ;; label = @15
                                  block  ;; label = @16
                                    local.get 12
                                    i32.load8_s
                                    local.tee 18
                                    i32.const -32
                                    i32.add
                                    local.tee 1
                                    i32.const 31
                                    i32.le_u
                                    br_if 0 (;@16;)
                                    local.get 12
                                    local.set 15
                                    br 1 (;@15;)
                                  end
                                  i32.const 0
                                  local.set 17
                                  local.get 12
                                  local.set 15
                                  i32.const 1
                                  local.get 1
                                  i32.shl
                                  local.tee 1
                                  i32.const 75913
                                  i32.and
                                  i32.eqz
                                  br_if 0 (;@15;)
                                  loop  ;; label = @16
                                    local.get 7
                                    local.get 12
                                    i32.const 1
                                    i32.add
                                    local.tee 15
                                    i32.store offset=60
                                    local.get 1
                                    local.get 17
                                    i32.or
                                    local.set 17
                                    local.get 12
                                    i32.load8_s offset=1
                                    local.tee 18
                                    i32.const -32
                                    i32.add
                                    local.tee 1
                                    i32.const 32
                                    i32.ge_u
                                    br_if 1 (;@15;)
                                    local.get 15
                                    local.set 12
                                    i32.const 1
                                    local.get 1
                                    i32.shl
                                    local.tee 1
                                    i32.const 75913
                                    i32.and
                                    br_if 0 (;@16;)
                                  end
                                end
                                block  ;; label = @15
                                  block  ;; label = @16
                                    local.get 18
                                    i32.const 42
                                    i32.ne
                                    br_if 0 (;@16;)
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        local.get 15
                                        i32.load8_s offset=1
                                        i32.const -48
                                        i32.add
                                        local.tee 12
                                        i32.const 9
                                        i32.gt_u
                                        br_if 0 (;@18;)
                                        local.get 15
                                        i32.load8_u offset=2
                                        i32.const 36
                                        i32.ne
                                        br_if 0 (;@18;)
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            local.get 0
                                            br_if 0 (;@20;)
                                            local.get 4
                                            local.get 12
                                            i32.const 2
                                            i32.shl
                                            i32.add
                                            i32.const 10
                                            i32.store
                                            i32.const 0
                                            local.set 19
                                            br 1 (;@19;)
                                          end
                                          local.get 3
                                          local.get 12
                                          i32.const 3
                                          i32.shl
                                          i32.add
                                          i32.load
                                          local.set 19
                                        end
                                        local.get 15
                                        i32.const 3
                                        i32.add
                                        local.set 1
                                        i32.const 1
                                        local.set 10
                                        br 1 (;@17;)
                                      end
                                      local.get 10
                                      br_if 6 (;@11;)
                                      local.get 15
                                      i32.const 1
                                      i32.add
                                      local.set 1
                                      block  ;; label = @18
                                        local.get 0
                                        br_if 0 (;@18;)
                                        local.get 7
                                        local.get 1
                                        i32.store offset=60
                                        i32.const 0
                                        local.set 10
                                        i32.const 0
                                        local.set 19
                                        br 3 (;@15;)
                                      end
                                      local.get 2
                                      local.get 2
                                      i32.load
                                      local.tee 12
                                      i32.const 4
                                      i32.add
                                      i32.store
                                      local.get 12
                                      i32.load
                                      local.set 19
                                      i32.const 0
                                      local.set 10
                                    end
                                    local.get 7
                                    local.get 1
                                    i32.store offset=60
                                    local.get 19
                                    i32.const -1
                                    i32.gt_s
                                    br_if 1 (;@15;)
                                    i32.const 0
                                    local.get 19
                                    i32.sub
                                    local.set 19
                                    local.get 17
                                    i32.const 8192
                                    i32.or
                                    local.set 17
                                    br 1 (;@15;)
                                  end
                                  local.get 7
                                  i32.const 60
                                  i32.add
                                  call $getint
                                  local.tee 19
                                  i32.const 0
                                  i32.lt_s
                                  br_if 11 (;@4;)
                                  local.get 7
                                  i32.load offset=60
                                  local.set 1
                                end
                                i32.const 0
                                local.set 12
                                i32.const -1
                                local.set 20
                                block  ;; label = @15
                                  block  ;; label = @16
                                    local.get 1
                                    i32.load8_u
                                    i32.const 46
                                    i32.eq
                                    br_if 0 (;@16;)
                                    i32.const 0
                                    local.set 21
                                    br 1 (;@15;)
                                  end
                                  block  ;; label = @16
                                    local.get 1
                                    i32.load8_u offset=1
                                    i32.const 42
                                    i32.ne
                                    br_if 0 (;@16;)
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        local.get 1
                                        i32.load8_s offset=2
                                        i32.const -48
                                        i32.add
                                        local.tee 15
                                        i32.const 9
                                        i32.gt_u
                                        br_if 0 (;@18;)
                                        local.get 1
                                        i32.load8_u offset=3
                                        i32.const 36
                                        i32.ne
                                        br_if 0 (;@18;)
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            local.get 0
                                            br_if 0 (;@20;)
                                            local.get 4
                                            local.get 15
                                            i32.const 2
                                            i32.shl
                                            i32.add
                                            i32.const 10
                                            i32.store
                                            i32.const 0
                                            local.set 20
                                            br 1 (;@19;)
                                          end
                                          local.get 3
                                          local.get 15
                                          i32.const 3
                                          i32.shl
                                          i32.add
                                          i32.load
                                          local.set 20
                                        end
                                        local.get 1
                                        i32.const 4
                                        i32.add
                                        local.set 1
                                        br 1 (;@17;)
                                      end
                                      local.get 10
                                      br_if 6 (;@11;)
                                      local.get 1
                                      i32.const 2
                                      i32.add
                                      local.set 1
                                      block  ;; label = @18
                                        local.get 0
                                        br_if 0 (;@18;)
                                        i32.const 0
                                        local.set 20
                                        br 1 (;@17;)
                                      end
                                      local.get 2
                                      local.get 2
                                      i32.load
                                      local.tee 15
                                      i32.const 4
                                      i32.add
                                      i32.store
                                      local.get 15
                                      i32.load
                                      local.set 20
                                    end
                                    local.get 7
                                    local.get 1
                                    i32.store offset=60
                                    local.get 20
                                    i32.const -1
                                    i32.gt_s
                                    local.set 21
                                    br 1 (;@15;)
                                  end
                                  local.get 7
                                  local.get 1
                                  i32.const 1
                                  i32.add
                                  i32.store offset=60
                                  i32.const 1
                                  local.set 21
                                  local.get 7
                                  i32.const 60
                                  i32.add
                                  call $getint
                                  local.set 20
                                  local.get 7
                                  i32.load offset=60
                                  local.set 1
                                end
                                loop  ;; label = @15
                                  local.get 12
                                  local.set 15
                                  i32.const 28
                                  local.set 22
                                  local.get 1
                                  local.tee 18
                                  i32.load8_s
                                  local.tee 12
                                  i32.const -123
                                  i32.add
                                  i32.const -58
                                  i32.lt_u
                                  br_if 12 (;@3;)
                                  local.get 18
                                  i32.const 1
                                  i32.add
                                  local.set 1
                                  local.get 12
                                  local.get 15
                                  i32.const 58
                                  i32.mul
                                  i32.add
                                  i32.const 71919
                                  i32.add
                                  i32.load8_u
                                  local.tee 12
                                  i32.const -1
                                  i32.add
                                  i32.const 255
                                  i32.and
                                  i32.const 8
                                  i32.lt_u
                                  br_if 0 (;@15;)
                                end
                                local.get 7
                                local.get 1
                                i32.store offset=60
                                block  ;; label = @15
                                  block  ;; label = @16
                                    local.get 12
                                    i32.const 27
                                    i32.eq
                                    br_if 0 (;@16;)
                                    local.get 12
                                    i32.eqz
                                    br_if 13 (;@3;)
                                    block  ;; label = @17
                                      local.get 16
                                      i32.const 0
                                      i32.lt_s
                                      br_if 0 (;@17;)
                                      block  ;; label = @18
                                        local.get 0
                                        br_if 0 (;@18;)
                                        local.get 4
                                        local.get 16
                                        i32.const 2
                                        i32.shl
                                        i32.add
                                        local.get 12
                                        i32.store
                                        br 13 (;@5;)
                                      end
                                      local.get 7
                                      local.get 3
                                      local.get 16
                                      i32.const 3
                                      i32.shl
                                      i32.add
                                      i64.load
                                      i64.store offset=48
                                      br 2 (;@15;)
                                    end
                                    local.get 0
                                    i32.eqz
                                    br_if 9 (;@7;)
                                    local.get 7
                                    i32.const 48
                                    i32.add
                                    local.get 12
                                    local.get 2
                                    local.get 6
                                    call $pop_arg
                                    br 1 (;@15;)
                                  end
                                  local.get 16
                                  i32.const -1
                                  i32.gt_s
                                  br_if 12 (;@3;)
                                  i32.const 0
                                  local.set 12
                                  local.get 0
                                  i32.eqz
                                  br_if 9 (;@6;)
                                end
                                local.get 0
                                i32.load8_u
                                i32.const 32
                                i32.and
                                br_if 12 (;@2;)
                                local.get 17
                                i32.const -65537
                                i32.and
                                local.tee 23
                                local.get 17
                                local.get 17
                                i32.const 8192
                                i32.and
                                select
                                local.set 17
                                i32.const 0
                                local.set 16
                                i32.const 65536
                                local.set 24
                                local.get 9
                                local.set 22
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              block  ;; label = @22
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        block  ;; label = @27
                                                          block  ;; label = @28
                                                            block  ;; label = @29
                                                              block  ;; label = @30
                                                                block  ;; label = @31
                                                                  local.get 18
                                                                  i32.load8_u
                                                                  local.tee 18
                                                                  i32.extend8_s
                                                                  local.tee 12
                                                                  i32.const -45
                                                                  i32.and
                                                                  local.get 12
                                                                  local.get 18
                                                                  i32.const 15
                                                                  i32.and
                                                                  i32.const 3
                                                                  i32.eq
                                                                  select
                                                                  local.get 12
                                                                  local.get 15
                                                                  select
                                                                  local.tee 12
                                                                  i32.const -88
                                                                  i32.add
                                                                  br_table 4 (;@27;) 23 (;@8;) 23 (;@8;) 23 (;@8;) 23 (;@8;) 23 (;@8;) 23 (;@8;) 23 (;@8;) 23 (;@8;) 16 (;@15;) 23 (;@8;) 9 (;@22;) 6 (;@25;) 16 (;@15;) 16 (;@15;) 16 (;@15;) 23 (;@8;) 6 (;@25;) 23 (;@8;) 23 (;@8;) 23 (;@8;) 23 (;@8;) 2 (;@29;) 5 (;@26;) 3 (;@28;) 23 (;@8;) 23 (;@8;) 10 (;@21;) 23 (;@8;) 1 (;@30;) 23 (;@8;) 23 (;@8;) 4 (;@27;) 0 (;@31;)
                                                                end
                                                                local.get 9
                                                                local.set 22
                                                                block  ;; label = @31
                                                                  local.get 12
                                                                  i32.const -65
                                                                  i32.add
                                                                  br_table 16 (;@15;) 23 (;@8;) 11 (;@20;) 23 (;@8;) 16 (;@15;) 16 (;@15;) 16 (;@15;) 0 (;@31;)
                                                                end
                                                                local.get 12
                                                                i32.const 83
                                                                i32.eq
                                                                br_if 11 (;@19;)
                                                                br 21 (;@9;)
                                                              end
                                                              i32.const 0
                                                              local.set 16
                                                              i32.const 65536
                                                              local.set 24
                                                              local.get 7
                                                              i64.load offset=48
                                                              local.set 25
                                                              br 5 (;@24;)
                                                            end
                                                            i32.const 0
                                                            local.set 12
                                                            block  ;; label = @29
                                                              block  ;; label = @30
                                                                block  ;; label = @31
                                                                  block  ;; label = @32
                                                                    block  ;; label = @33
                                                                      block  ;; label = @34
                                                                        block  ;; label = @35
                                                                          local.get 15
                                                                          br_table 0 (;@35;) 1 (;@34;) 2 (;@33;) 3 (;@32;) 4 (;@31;) 29 (;@6;) 5 (;@30;) 6 (;@29;) 29 (;@6;)
                                                                        end
                                                                        local.get 7
                                                                        i32.load offset=48
                                                                        local.get 11
                                                                        i32.store
                                                                        br 28 (;@6;)
                                                                      end
                                                                      local.get 7
                                                                      i32.load offset=48
                                                                      local.get 11
                                                                      i32.store
                                                                      br 27 (;@6;)
                                                                    end
                                                                    local.get 7
                                                                    i32.load offset=48
                                                                    local.get 11
                                                                    i64.extend_i32_s
                                                                    i64.store
                                                                    br 26 (;@6;)
                                                                  end
                                                                  local.get 7
                                                                  i32.load offset=48
                                                                  local.get 11
                                                                  i32.store16
                                                                  br 25 (;@6;)
                                                                end
                                                                local.get 7
                                                                i32.load offset=48
                                                                local.get 11
                                                                i32.store8
                                                                br 24 (;@6;)
                                                              end
                                                              local.get 7
                                                              i32.load offset=48
                                                              local.get 11
                                                              i32.store
                                                              br 23 (;@6;)
                                                            end
                                                            local.get 7
                                                            i32.load offset=48
                                                            local.get 11
                                                            i64.extend_i32_s
                                                            i64.store
                                                            br 22 (;@6;)
                                                          end
                                                          local.get 20
                                                          i32.const 8
                                                          local.get 20
                                                          i32.const 8
                                                          i32.gt_u
                                                          select
                                                          local.set 20
                                                          local.get 17
                                                          i32.const 8
                                                          i32.or
                                                          local.set 17
                                                          i32.const 120
                                                          local.set 12
                                                        end
                                                        i32.const 0
                                                        local.set 16
                                                        i32.const 65536
                                                        local.set 24
                                                        local.get 7
                                                        i64.load offset=48
                                                        local.tee 25
                                                        local.get 9
                                                        local.get 12
                                                        i32.const 32
                                                        i32.and
                                                        call $fmt_x
                                                        local.set 13
                                                        local.get 25
                                                        i64.eqz
                                                        br_if 3 (;@23;)
                                                        local.get 17
                                                        i32.const 8
                                                        i32.and
                                                        i32.eqz
                                                        br_if 3 (;@23;)
                                                        local.get 12
                                                        i32.const 4
                                                        i32.shr_u
                                                        i32.const 65536
                                                        i32.add
                                                        local.set 24
                                                        i32.const 2
                                                        local.set 16
                                                        br 3 (;@23;)
                                                      end
                                                      i32.const 0
                                                      local.set 16
                                                      i32.const 65536
                                                      local.set 24
                                                      local.get 7
                                                      i64.load offset=48
                                                      local.tee 25
                                                      local.get 9
                                                      call $fmt_o
                                                      local.set 13
                                                      local.get 17
                                                      i32.const 8
                                                      i32.and
                                                      i32.eqz
                                                      br_if 2 (;@23;)
                                                      local.get 20
                                                      local.get 9
                                                      local.get 13
                                                      i32.sub
                                                      local.tee 12
                                                      i32.const 1
                                                      i32.add
                                                      local.get 20
                                                      local.get 12
                                                      i32.gt_s
                                                      select
                                                      local.set 20
                                                      br 2 (;@23;)
                                                    end
                                                    block  ;; label = @25
                                                      local.get 7
                                                      i64.load offset=48
                                                      local.tee 25
                                                      i64.const -1
                                                      i64.gt_s
                                                      br_if 0 (;@25;)
                                                      local.get 7
                                                      i64.const 0
                                                      local.get 25
                                                      i64.sub
                                                      local.tee 25
                                                      i64.store offset=48
                                                      i32.const 1
                                                      local.set 16
                                                      i32.const 65536
                                                      local.set 24
                                                      br 1 (;@24;)
                                                    end
                                                    block  ;; label = @25
                                                      local.get 17
                                                      i32.const 2048
                                                      i32.and
                                                      i32.eqz
                                                      br_if 0 (;@25;)
                                                      i32.const 1
                                                      local.set 16
                                                      i32.const 65537
                                                      local.set 24
                                                      br 1 (;@24;)
                                                    end
                                                    i32.const 65538
                                                    i32.const 65536
                                                    local.get 17
                                                    i32.const 1
                                                    i32.and
                                                    local.tee 16
                                                    select
                                                    local.set 24
                                                  end
                                                  local.get 25
                                                  local.get 9
                                                  call $fmt_u
                                                  local.set 13
                                                end
                                                local.get 21
                                                local.get 20
                                                i32.const 0
                                                i32.lt_s
                                                i32.and
                                                br_if 18 (;@4;)
                                                local.get 17
                                                i32.const -65537
                                                i32.and
                                                local.get 17
                                                local.get 21
                                                select
                                                local.set 17
                                                block  ;; label = @23
                                                  local.get 25
                                                  i64.const 0
                                                  i64.ne
                                                  br_if 0 (;@23;)
                                                  local.get 20
                                                  br_if 0 (;@23;)
                                                  local.get 9
                                                  local.set 13
                                                  local.get 9
                                                  local.set 22
                                                  i32.const 0
                                                  local.set 20
                                                  br 15 (;@8;)
                                                end
                                                local.get 20
                                                local.get 9
                                                local.get 13
                                                i32.sub
                                                local.get 25
                                                i64.eqz
                                                i32.add
                                                local.tee 12
                                                local.get 20
                                                local.get 12
                                                i32.gt_s
                                                select
                                                local.set 20
                                                br 13 (;@9;)
                                              end
                                              local.get 7
                                              i32.load8_u offset=48
                                              local.set 12
                                              br 11 (;@10;)
                                            end
                                            local.get 7
                                            i32.load offset=48
                                            local.tee 12
                                            i32.const 65642
                                            local.get 12
                                            select
                                            local.set 13
                                            local.get 13
                                            local.get 13
                                            local.get 20
                                            i32.const 2147483647
                                            local.get 20
                                            i32.const 2147483647
                                            i32.lt_u
                                            select
                                            call $strnlen
                                            local.tee 12
                                            i32.add
                                            local.set 22
                                            block  ;; label = @21
                                              local.get 20
                                              i32.const -1
                                              i32.le_s
                                              br_if 0 (;@21;)
                                              local.get 23
                                              local.set 17
                                              local.get 12
                                              local.set 20
                                              br 13 (;@8;)
                                            end
                                            local.get 23
                                            local.set 17
                                            local.get 12
                                            local.set 20
                                            local.get 22
                                            i32.load8_u
                                            br_if 16 (;@4;)
                                            br 12 (;@8;)
                                          end
                                          local.get 7
                                          i64.load offset=48
                                          local.tee 25
                                          i64.eqz
                                          i32.eqz
                                          br_if 1 (;@18;)
                                          i32.const 0
                                          local.set 12
                                          br 9 (;@10;)
                                        end
                                        block  ;; label = @19
                                          local.get 20
                                          i32.eqz
                                          br_if 0 (;@19;)
                                          local.get 7
                                          i32.load offset=48
                                          local.set 14
                                          br 2 (;@17;)
                                        end
                                        i32.const 0
                                        local.set 12
                                        local.get 0
                                        i32.const 32
                                        local.get 19
                                        i32.const 0
                                        local.get 17
                                        call $pad
                                        br 2 (;@16;)
                                      end
                                      local.get 7
                                      i32.const 0
                                      i32.store offset=12
                                      local.get 7
                                      local.get 25
                                      i64.store32 offset=8
                                      local.get 7
                                      local.get 7
                                      i32.const 8
                                      i32.add
                                      i32.store offset=48
                                      local.get 7
                                      i32.const 8
                                      i32.add
                                      local.set 14
                                      i32.const -1
                                      local.set 20
                                    end
                                    i32.const 0
                                    local.set 12
                                    block  ;; label = @17
                                      loop  ;; label = @18
                                        local.get 14
                                        i32.load
                                        local.tee 15
                                        i32.eqz
                                        br_if 1 (;@17;)
                                        local.get 7
                                        i32.const 4
                                        i32.add
                                        local.get 15
                                        call $wctomb
                                        local.tee 15
                                        i32.const 0
                                        i32.lt_s
                                        br_if 16 (;@2;)
                                        local.get 15
                                        local.get 20
                                        local.get 12
                                        i32.sub
                                        i32.gt_u
                                        br_if 1 (;@17;)
                                        local.get 14
                                        i32.const 4
                                        i32.add
                                        local.set 14
                                        local.get 15
                                        local.get 12
                                        i32.add
                                        local.tee 12
                                        local.get 20
                                        i32.lt_u
                                        br_if 0 (;@18;)
                                      end
                                    end
                                    i32.const 61
                                    local.set 22
                                    local.get 12
                                    i32.const 0
                                    i32.lt_s
                                    br_if 13 (;@3;)
                                    local.get 0
                                    i32.const 32
                                    local.get 19
                                    local.get 12
                                    local.get 17
                                    call $pad
                                    block  ;; label = @17
                                      local.get 12
                                      br_if 0 (;@17;)
                                      i32.const 0
                                      local.set 12
                                      br 1 (;@16;)
                                    end
                                    i32.const 0
                                    local.set 15
                                    local.get 7
                                    i32.load offset=48
                                    local.set 14
                                    loop  ;; label = @17
                                      local.get 14
                                      i32.load
                                      local.tee 13
                                      i32.eqz
                                      br_if 1 (;@16;)
                                      local.get 7
                                      i32.const 4
                                      i32.add
                                      local.get 13
                                      call $wctomb
                                      local.tee 13
                                      local.get 15
                                      i32.add
                                      local.tee 15
                                      local.get 12
                                      i32.gt_u
                                      br_if 1 (;@16;)
                                      local.get 0
                                      local.get 7
                                      i32.const 4
                                      i32.add
                                      local.get 13
                                      call $out
                                      local.get 14
                                      i32.const 4
                                      i32.add
                                      local.set 14
                                      local.get 15
                                      local.get 12
                                      i32.lt_u
                                      br_if 0 (;@17;)
                                    end
                                  end
                                  local.get 0
                                  i32.const 32
                                  local.get 19
                                  local.get 12
                                  local.get 17
                                  i32.const 8192
                                  i32.xor
                                  call $pad
                                  local.get 19
                                  local.get 12
                                  local.get 19
                                  local.get 12
                                  i32.gt_s
                                  select
                                  local.set 12
                                  br 9 (;@6;)
                                end
                                local.get 21
                                local.get 20
                                i32.const 0
                                i32.lt_s
                                i32.and
                                br_if 10 (;@4;)
                                i32.const 61
                                local.set 22
                                local.get 0
                                local.get 7
                                f64.load offset=48
                                local.get 19
                                local.get 20
                                local.get 17
                                local.get 12
                                local.get 5
                                call_indirect (type 3)
                                local.tee 12
                                i32.const 0
                                i32.ge_s
                                br_if 8 (;@6;)
                                br 11 (;@3;)
                              end
                              local.get 12
                              i32.load8_u offset=1
                              local.set 14
                              local.get 12
                              i32.const 1
                              i32.add
                              local.set 12
                              br 0 (;@13;)
                            end
                          end
                          local.get 0
                          br_if 10 (;@1;)
                          local.get 10
                          i32.eqz
                          br_if 4 (;@7;)
                          i32.const 1
                          local.set 12
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 4
                              local.get 12
                              i32.const 2
                              i32.shl
                              i32.add
                              i32.load
                              local.tee 14
                              i32.eqz
                              br_if 1 (;@12;)
                              local.get 3
                              local.get 12
                              i32.const 3
                              i32.shl
                              i32.add
                              local.get 14
                              local.get 2
                              local.get 6
                              call $pop_arg
                              i32.const 1
                              local.set 11
                              local.get 12
                              i32.const 1
                              i32.add
                              local.tee 12
                              i32.const 10
                              i32.ne
                              br_if 0 (;@13;)
                              br 12 (;@1;)
                            end
                          end
                          block  ;; label = @12
                            local.get 12
                            i32.const 10
                            i32.lt_u
                            br_if 0 (;@12;)
                            i32.const 1
                            local.set 11
                            br 11 (;@1;)
                          end
                          loop  ;; label = @12
                            local.get 4
                            local.get 12
                            i32.const 2
                            i32.shl
                            i32.add
                            i32.load
                            br_if 1 (;@11;)
                            i32.const 1
                            local.set 11
                            local.get 12
                            i32.const 1
                            i32.add
                            local.tee 12
                            i32.const 10
                            i32.eq
                            br_if 11 (;@1;)
                            br 0 (;@12;)
                          end
                        end
                        i32.const 28
                        local.set 22
                        br 7 (;@3;)
                      end
                      local.get 7
                      local.get 12
                      i32.store8 offset=39
                      i32.const 1
                      local.set 20
                      local.get 8
                      local.set 13
                      local.get 9
                      local.set 22
                      local.get 23
                      local.set 17
                      br 1 (;@8;)
                    end
                    local.get 9
                    local.set 22
                  end
                  local.get 20
                  local.get 22
                  local.get 13
                  i32.sub
                  local.tee 1
                  local.get 20
                  local.get 1
                  i32.gt_s
                  select
                  local.tee 18
                  local.get 16
                  i32.const 2147483647
                  i32.xor
                  i32.gt_s
                  br_if 3 (;@4;)
                  i32.const 61
                  local.set 22
                  local.get 19
                  local.get 16
                  local.get 18
                  i32.add
                  local.tee 15
                  local.get 19
                  local.get 15
                  i32.gt_s
                  select
                  local.tee 12
                  local.get 14
                  i32.gt_s
                  br_if 4 (;@3;)
                  local.get 0
                  i32.const 32
                  local.get 12
                  local.get 15
                  local.get 17
                  call $pad
                  local.get 0
                  local.get 24
                  local.get 16
                  call $out
                  local.get 0
                  i32.const 48
                  local.get 12
                  local.get 15
                  local.get 17
                  i32.const 65536
                  i32.xor
                  call $pad
                  local.get 0
                  i32.const 48
                  local.get 18
                  local.get 1
                  i32.const 0
                  call $pad
                  local.get 0
                  local.get 13
                  local.get 1
                  call $out
                  local.get 0
                  i32.const 32
                  local.get 12
                  local.get 15
                  local.get 17
                  i32.const 8192
                  i32.xor
                  call $pad
                  local.get 7
                  i32.load offset=60
                  local.set 1
                  br 1 (;@6;)
                end
              end
            end
            i32.const 0
            local.set 11
            br 3 (;@1;)
          end
          i32.const 61
          local.set 22
        end
        call $__errno_location
        local.get 22
        i32.store
      end
      i32.const -1
      local.set 11
    end
    local.get 7
    i32.const 64
    i32.add
    global.set $__stack_pointer
    local.get 11)
  (func $out (type 24) (param i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load8_u
      i32.const 32
      i32.and
      br_if 0 (;@1;)
      local.get 1
      local.get 2
      local.get 0
      call $__fwritex
      drop
    end)
  (func $getint (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 i32)
    i32.const 0
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 2
      i32.load8_s
      i32.const -48
      i32.add
      local.tee 3
      i32.const 9
      i32.le_u
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    loop  ;; label = @1
      i32.const -1
      local.set 4
      block  ;; label = @2
        local.get 1
        i32.const 214748364
        i32.gt_u
        br_if 0 (;@2;)
        i32.const -1
        local.get 3
        local.get 1
        i32.const 10
        i32.mul
        local.tee 1
        i32.add
        local.get 3
        local.get 1
        i32.const 2147483647
        i32.xor
        i32.gt_u
        select
        local.set 4
      end
      local.get 0
      local.get 2
      i32.const 1
      i32.add
      local.tee 3
      i32.store
      local.get 2
      i32.load8_s offset=1
      local.set 5
      local.get 4
      local.set 1
      local.get 3
      local.set 2
      local.get 5
      i32.const -48
      i32.add
      local.tee 3
      i32.const 10
      i32.lt_u
      br_if 0 (;@1;)
    end
    local.get 4)
  (func $pop_arg (type 25) (param i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          local.get 1
                                          i32.const -9
                                          i32.add
                                          br_table 0 (;@19;) 1 (;@18;) 2 (;@17;) 5 (;@14;) 3 (;@16;) 4 (;@15;) 6 (;@13;) 7 (;@12;) 8 (;@11;) 9 (;@10;) 10 (;@9;) 11 (;@8;) 12 (;@7;) 13 (;@6;) 14 (;@5;) 15 (;@4;) 16 (;@3;) 17 (;@2;) 18 (;@1;)
                                        end
                                        local.get 2
                                        local.get 2
                                        i32.load
                                        local.tee 1
                                        i32.const 4
                                        i32.add
                                        i32.store
                                        local.get 0
                                        local.get 1
                                        i32.load
                                        i32.store
                                        return
                                      end
                                      local.get 2
                                      local.get 2
                                      i32.load
                                      local.tee 1
                                      i32.const 4
                                      i32.add
                                      i32.store
                                      local.get 0
                                      local.get 1
                                      i64.load32_s
                                      i64.store
                                      return
                                    end
                                    local.get 2
                                    local.get 2
                                    i32.load
                                    local.tee 1
                                    i32.const 4
                                    i32.add
                                    i32.store
                                    local.get 0
                                    local.get 1
                                    i64.load32_u
                                    i64.store
                                    return
                                  end
                                  local.get 2
                                  local.get 2
                                  i32.load
                                  local.tee 1
                                  i32.const 4
                                  i32.add
                                  i32.store
                                  local.get 0
                                  local.get 1
                                  i64.load32_s
                                  i64.store
                                  return
                                end
                                local.get 2
                                local.get 2
                                i32.load
                                local.tee 1
                                i32.const 4
                                i32.add
                                i32.store
                                local.get 0
                                local.get 1
                                i64.load32_u
                                i64.store
                                return
                              end
                              local.get 2
                              local.get 2
                              i32.load
                              i32.const 7
                              i32.add
                              i32.const -8
                              i32.and
                              local.tee 1
                              i32.const 8
                              i32.add
                              i32.store
                              local.get 0
                              local.get 1
                              i64.load
                              i64.store
                              return
                            end
                            local.get 2
                            local.get 2
                            i32.load
                            local.tee 1
                            i32.const 4
                            i32.add
                            i32.store
                            local.get 0
                            local.get 1
                            i64.load16_s
                            i64.store
                            return
                          end
                          local.get 2
                          local.get 2
                          i32.load
                          local.tee 1
                          i32.const 4
                          i32.add
                          i32.store
                          local.get 0
                          local.get 1
                          i64.load16_u
                          i64.store
                          return
                        end
                        local.get 2
                        local.get 2
                        i32.load
                        local.tee 1
                        i32.const 4
                        i32.add
                        i32.store
                        local.get 0
                        local.get 1
                        i64.load8_s
                        i64.store
                        return
                      end
                      local.get 2
                      local.get 2
                      i32.load
                      local.tee 1
                      i32.const 4
                      i32.add
                      i32.store
                      local.get 0
                      local.get 1
                      i64.load8_u
                      i64.store
                      return
                    end
                    local.get 2
                    local.get 2
                    i32.load
                    i32.const 7
                    i32.add
                    i32.const -8
                    i32.and
                    local.tee 1
                    i32.const 8
                    i32.add
                    i32.store
                    local.get 0
                    local.get 1
                    i64.load
                    i64.store
                    return
                  end
                  local.get 2
                  local.get 2
                  i32.load
                  local.tee 1
                  i32.const 4
                  i32.add
                  i32.store
                  local.get 0
                  local.get 1
                  i64.load32_u
                  i64.store
                  return
                end
                local.get 2
                local.get 2
                i32.load
                i32.const 7
                i32.add
                i32.const -8
                i32.and
                local.tee 1
                i32.const 8
                i32.add
                i32.store
                local.get 0
                local.get 1
                i64.load
                i64.store
                return
              end
              local.get 2
              local.get 2
              i32.load
              i32.const 7
              i32.add
              i32.const -8
              i32.and
              local.tee 1
              i32.const 8
              i32.add
              i32.store
              local.get 0
              local.get 1
              i64.load
              i64.store
              return
            end
            local.get 2
            local.get 2
            i32.load
            local.tee 1
            i32.const 4
            i32.add
            i32.store
            local.get 0
            local.get 1
            i64.load32_s
            i64.store
            return
          end
          local.get 2
          local.get 2
          i32.load
          local.tee 1
          i32.const 4
          i32.add
          i32.store
          local.get 0
          local.get 1
          i64.load32_u
          i64.store
          return
        end
        local.get 2
        local.get 2
        i32.load
        i32.const 7
        i32.add
        i32.const -8
        i32.and
        local.tee 1
        i32.const 8
        i32.add
        i32.store
        local.get 0
        local.get 1
        f64.load
        f64.store
        return
      end
      local.get 0
      local.get 2
      local.get 3
      call_indirect (type 4)
    end)
  (func $fmt_x (type 26) (param i64 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i64.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 0
        i32.wrap_i64
        i32.const 15
        i32.and
        i32.const 72448
        i32.add
        i32.load8_u
        local.get 2
        i32.or
        i32.store8
        local.get 0
        i64.const 15
        i64.gt_u
        local.set 3
        local.get 0
        i64.const 4
        i64.shr_u
        local.set 0
        local.get 3
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $fmt_o (type 27) (param i64 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i64.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 0
        i32.wrap_i64
        i32.const 7
        i32.and
        i32.const 48
        i32.or
        i32.store8
        local.get 0
        i64.const 7
        i64.gt_u
        local.set 2
        local.get 0
        i64.const 3
        i64.shr_u
        local.set 0
        local.get 2
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $fmt_u (type 27) (param i64 i32) (result i32)
    (local i64 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.const 4294967296
        i64.ge_u
        br_if 0 (;@2;)
        local.get 0
        local.set 2
        br 1 (;@1;)
      end
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 0
        local.get 0
        i64.const 10
        i64.div_u
        local.tee 2
        i64.const 10
        i64.mul
        i64.sub
        i32.wrap_i64
        i32.const 48
        i32.or
        i32.store8
        local.get 0
        i64.const 42949672959
        i64.gt_u
        local.set 3
        local.get 2
        local.set 0
        local.get 3
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      i64.eqz
      br_if 0 (;@1;)
      local.get 2
      i32.wrap_i64
      local.set 3
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 3
        local.get 3
        i32.const 10
        i32.div_u
        local.tee 4
        i32.const 10
        i32.mul
        i32.sub
        i32.const 48
        i32.or
        i32.store8
        local.get 3
        i32.const 9
        i32.gt_u
        local.set 5
        local.get 4
        local.set 3
        local.get 5
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $pad (type 28) (param i32 i32 i32 i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 256
    i32.sub
    local.tee 5
    global.set $__stack_pointer
    block  ;; label = @1
      local.get 2
      local.get 3
      i32.le_s
      br_if 0 (;@1;)
      local.get 4
      i32.const 73728
      i32.and
      br_if 0 (;@1;)
      local.get 5
      local.get 1
      local.get 2
      local.get 3
      i32.sub
      local.tee 3
      i32.const 256
      local.get 3
      i32.const 256
      i32.lt_u
      local.tee 2
      select
      call $__memset
      drop
      block  ;; label = @2
        local.get 2
        br_if 0 (;@2;)
        loop  ;; label = @3
          local.get 0
          local.get 5
          i32.const 256
          call $out
          local.get 3
          i32.const -256
          i32.add
          local.tee 3
          i32.const 255
          i32.gt_u
          br_if 0 (;@3;)
        end
      end
      local.get 0
      local.get 5
      local.get 3
      call $out
    end
    local.get 5
    i32.const 256
    i32.add
    global.set $__stack_pointer)
  (func $vfprintf (type 2) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    i32.const 1
    i32.const 2
    call $__vfprintf_internal)
  (func $fmt_fp (type 3) (param i32 f64 i32 i32 i32 i32) (result i32)
    (local i32 i32 i64 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i64 i32 i32 i32 i32 f64)
    global.get $__stack_pointer
    i32.const 560
    i32.sub
    local.tee 6
    global.set $__stack_pointer
    i32.const 0
    local.set 7
    local.get 6
    i32.const 0
    i32.store offset=44
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        call $__DOUBLE_BITS
        local.tee 8
        i64.const -1
        i64.gt_s
        br_if 0 (;@2;)
        i32.const 1
        local.set 9
        i32.const 65546
        local.set 10
        local.get 1
        f64.neg
        local.tee 1
        call $__DOUBLE_BITS
        local.set 8
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 4
        i32.const 2048
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        i32.const 1
        local.set 9
        i32.const 65549
        local.set 10
        br 1 (;@1;)
      end
      i32.const 65552
      i32.const 65547
      local.get 4
      i32.const 1
      i32.and
      local.tee 9
      select
      local.set 10
      local.get 9
      i32.eqz
      local.set 7
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 8
        i64.const 9218868437227405312
        i64.and
        i64.const 9218868437227405312
        i64.ne
        br_if 0 (;@2;)
        local.get 0
        i32.const 32
        local.get 2
        local.get 9
        i32.const 3
        i32.add
        local.tee 11
        local.get 4
        i32.const -65537
        i32.and
        call $pad
        local.get 0
        local.get 10
        local.get 9
        call $out
        local.get 0
        i32.const 65565
        i32.const 65573
        local.get 5
        i32.const 32
        i32.and
        local.tee 12
        select
        i32.const 65569
        i32.const 65577
        local.get 12
        select
        local.get 1
        local.get 1
        f64.ne
        select
        i32.const 3
        call $out
        local.get 0
        i32.const 32
        local.get 2
        local.get 11
        local.get 4
        i32.const 8192
        i32.xor
        call $pad
        local.get 2
        local.get 11
        local.get 2
        local.get 11
        i32.gt_s
        select
        local.set 13
        br 1 (;@1;)
      end
      local.get 6
      i32.const 16
      i32.add
      local.set 14
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              local.get 6
              i32.const 44
              i32.add
              call $frexp
              local.tee 1
              local.get 1
              f64.add
              local.tee 1
              f64.const 0x0p+0 (;=0;)
              f64.eq
              br_if 0 (;@5;)
              local.get 6
              local.get 6
              i32.load offset=44
              local.tee 11
              i32.const -1
              i32.add
              i32.store offset=44
              local.get 5
              i32.const 32
              i32.or
              local.tee 15
              i32.const 97
              i32.ne
              br_if 1 (;@4;)
              br 3 (;@2;)
            end
            local.get 5
            i32.const 32
            i32.or
            local.tee 15
            i32.const 97
            i32.eq
            br_if 2 (;@2;)
            i32.const 6
            local.get 3
            local.get 3
            i32.const 0
            i32.lt_s
            select
            local.set 16
            local.get 6
            i32.load offset=44
            local.set 17
            br 1 (;@3;)
          end
          local.get 6
          local.get 11
          i32.const -29
          i32.add
          local.tee 17
          i32.store offset=44
          i32.const 6
          local.get 3
          local.get 3
          i32.const 0
          i32.lt_s
          select
          local.set 16
          local.get 1
          f64.const 0x1p+28 (;=2.68435e+08;)
          f64.mul
          local.set 1
        end
        local.get 6
        i32.const 48
        i32.add
        i32.const 0
        i32.const 288
        local.get 17
        i32.const 0
        i32.lt_s
        select
        i32.add
        local.tee 18
        local.set 12
        loop  ;; label = @3
          local.get 12
          local.get 1
          i32.trunc_sat_f64_u
          local.tee 11
          i32.store
          local.get 12
          i32.const 4
          i32.add
          local.set 12
          local.get 1
          local.get 11
          f64.convert_i32_u
          f64.sub
          f64.const 0x1.dcd65p+29 (;=1e+09;)
          f64.mul
          local.tee 1
          f64.const 0x0p+0 (;=0;)
          f64.ne
          br_if 0 (;@3;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 17
            i32.const 1
            i32.ge_s
            br_if 0 (;@4;)
            local.get 17
            local.set 19
            local.get 12
            local.set 11
            local.get 18
            local.set 20
            br 1 (;@3;)
          end
          local.get 18
          local.set 20
          local.get 17
          local.set 19
          loop  ;; label = @4
            local.get 19
            i32.const 29
            local.get 19
            i32.const 29
            i32.lt_u
            select
            local.set 19
            block  ;; label = @5
              local.get 12
              i32.const -4
              i32.add
              local.tee 11
              local.get 20
              i32.lt_u
              br_if 0 (;@5;)
              local.get 19
              i64.extend_i32_u
              local.set 21
              i64.const 0
              local.set 8
              loop  ;; label = @6
                local.get 11
                local.get 11
                i64.load32_u
                local.get 21
                i64.shl
                local.get 8
                i64.const 4294967295
                i64.and
                i64.add
                local.tee 22
                local.get 22
                i64.const 1000000000
                i64.div_u
                local.tee 8
                i64.const 1000000000
                i64.mul
                i64.sub
                i64.store32
                local.get 11
                i32.const -4
                i32.add
                local.tee 11
                local.get 20
                i32.ge_u
                br_if 0 (;@6;)
              end
              local.get 22
              i64.const 1000000000
              i64.lt_u
              br_if 0 (;@5;)
              local.get 20
              i32.const -4
              i32.add
              local.tee 20
              local.get 8
              i64.store32
            end
            block  ;; label = @5
              loop  ;; label = @6
                local.get 12
                local.tee 11
                local.get 20
                i32.le_u
                br_if 1 (;@5;)
                local.get 11
                i32.const -4
                i32.add
                local.tee 12
                i32.load
                i32.eqz
                br_if 0 (;@6;)
              end
            end
            local.get 6
            local.get 6
            i32.load offset=44
            local.get 19
            i32.sub
            local.tee 19
            i32.store offset=44
            local.get 11
            local.set 12
            local.get 19
            i32.const 0
            i32.gt_s
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 19
          i32.const -1
          i32.gt_s
          br_if 0 (;@3;)
          local.get 16
          i32.const 25
          i32.add
          i32.const 9
          i32.div_u
          i32.const 1
          i32.add
          local.set 23
          local.get 15
          i32.const 102
          i32.eq
          local.set 24
          loop  ;; label = @4
            i32.const 0
            local.get 19
            i32.sub
            local.tee 12
            i32.const 9
            local.get 12
            i32.const 9
            i32.lt_u
            select
            local.set 13
            block  ;; label = @5
              block  ;; label = @6
                local.get 20
                local.get 11
                i32.lt_u
                br_if 0 (;@6;)
                i32.const 0
                i32.const 4
                local.get 20
                i32.load
                select
                local.set 12
                br 1 (;@5;)
              end
              i32.const 1000000000
              local.get 13
              i32.shr_u
              local.set 25
              i32.const -1
              local.get 13
              i32.shl
              i32.const -1
              i32.xor
              local.set 26
              i32.const 0
              local.set 19
              local.get 20
              local.set 12
              loop  ;; label = @6
                local.get 12
                local.get 12
                i32.load
                local.tee 3
                local.get 13
                i32.shr_u
                local.get 19
                i32.add
                i32.store
                local.get 3
                local.get 26
                i32.and
                local.get 25
                i32.mul
                local.set 19
                local.get 12
                i32.const 4
                i32.add
                local.tee 12
                local.get 11
                i32.lt_u
                br_if 0 (;@6;)
              end
              i32.const 0
              i32.const 4
              local.get 20
              i32.load
              select
              local.set 12
              local.get 19
              i32.eqz
              br_if 0 (;@5;)
              local.get 11
              local.get 19
              i32.store
              local.get 11
              i32.const 4
              i32.add
              local.set 11
            end
            local.get 6
            local.get 6
            i32.load offset=44
            local.get 13
            i32.add
            local.tee 19
            i32.store offset=44
            local.get 18
            local.get 20
            local.get 12
            i32.add
            local.tee 20
            local.get 24
            select
            local.tee 12
            local.get 23
            i32.const 2
            i32.shl
            i32.add
            local.get 11
            local.get 11
            local.get 12
            i32.sub
            i32.const 2
            i32.shr_s
            local.get 23
            i32.gt_s
            select
            local.set 11
            local.get 19
            i32.const 0
            i32.lt_s
            br_if 0 (;@4;)
          end
        end
        i32.const 0
        local.set 19
        block  ;; label = @3
          local.get 20
          local.get 11
          i32.ge_u
          br_if 0 (;@3;)
          local.get 18
          local.get 20
          i32.sub
          i32.const 2
          i32.shr_s
          i32.const 9
          i32.mul
          local.set 19
          i32.const 10
          local.set 12
          local.get 20
          i32.load
          local.tee 3
          i32.const 10
          i32.lt_u
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 19
            i32.const 1
            i32.add
            local.set 19
            local.get 3
            local.get 12
            i32.const 10
            i32.mul
            local.tee 12
            i32.ge_u
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 16
          i32.const 0
          local.get 19
          local.get 15
          i32.const 102
          i32.eq
          select
          i32.sub
          local.get 16
          i32.const 0
          i32.ne
          local.get 15
          i32.const 103
          i32.eq
          i32.and
          i32.sub
          local.tee 12
          local.get 11
          local.get 18
          i32.sub
          i32.const 2
          i32.shr_s
          i32.const 9
          i32.mul
          i32.const -9
          i32.add
          i32.ge_s
          br_if 0 (;@3;)
          local.get 6
          i32.const 48
          i32.add
          i32.const -4092
          i32.const -3804
          local.get 17
          i32.const 0
          i32.lt_s
          select
          i32.add
          local.get 12
          i32.const 9216
          i32.add
          local.tee 3
          i32.const 9
          i32.div_s
          local.tee 25
          i32.const 2
          i32.shl
          i32.add
          local.set 13
          i32.const 10
          local.set 12
          block  ;; label = @4
            local.get 3
            local.get 25
            i32.const 9
            i32.mul
            i32.sub
            local.tee 3
            i32.const 7
            i32.gt_s
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 12
              i32.const 10
              i32.mul
              local.set 12
              local.get 3
              i32.const 1
              i32.add
              local.tee 3
              i32.const 8
              i32.ne
              br_if 0 (;@5;)
            end
          end
          local.get 13
          i32.const 4
          i32.add
          local.set 26
          block  ;; label = @4
            block  ;; label = @5
              local.get 13
              i32.load
              local.tee 3
              local.get 3
              local.get 12
              i32.div_u
              local.tee 23
              local.get 12
              i32.mul
              i32.sub
              local.tee 25
              br_if 0 (;@5;)
              local.get 26
              local.get 11
              i32.eq
              br_if 1 (;@4;)
            end
            block  ;; label = @5
              block  ;; label = @6
                local.get 23
                i32.const 1
                i32.and
                br_if 0 (;@6;)
                f64.const 0x1p+53 (;=9.0072e+15;)
                local.set 1
                local.get 12
                i32.const 1000000000
                i32.ne
                br_if 1 (;@5;)
                local.get 13
                local.get 20
                i32.le_u
                br_if 1 (;@5;)
                local.get 13
                i32.const -4
                i32.add
                i32.load8_u
                i32.const 1
                i32.and
                i32.eqz
                br_if 1 (;@5;)
              end
              f64.const 0x1.0000000000001p+53 (;=9.0072e+15;)
              local.set 1
            end
            f64.const 0x1p-1 (;=0.5;)
            f64.const 0x1p+0 (;=1;)
            f64.const 0x1.8p+0 (;=1.5;)
            local.get 26
            local.get 11
            i32.eq
            select
            f64.const 0x1.8p+0 (;=1.5;)
            local.get 25
            local.get 12
            i32.const 1
            i32.shr_u
            local.tee 26
            i32.eq
            select
            local.get 25
            local.get 26
            i32.lt_u
            select
            local.set 27
            block  ;; label = @5
              local.get 7
              br_if 0 (;@5;)
              local.get 10
              i32.load8_u
              i32.const 45
              i32.ne
              br_if 0 (;@5;)
              local.get 27
              f64.neg
              local.set 27
              local.get 1
              f64.neg
              local.set 1
            end
            local.get 13
            local.get 3
            local.get 25
            i32.sub
            local.tee 3
            i32.store
            local.get 1
            local.get 27
            f64.add
            local.get 1
            f64.eq
            br_if 0 (;@4;)
            local.get 13
            local.get 3
            local.get 12
            i32.add
            local.tee 12
            i32.store
            block  ;; label = @5
              local.get 12
              i32.const 1000000000
              i32.lt_u
              br_if 0 (;@5;)
              loop  ;; label = @6
                local.get 13
                i32.const 0
                i32.store
                block  ;; label = @7
                  local.get 13
                  i32.const -4
                  i32.add
                  local.tee 13
                  local.get 20
                  i32.ge_u
                  br_if 0 (;@7;)
                  local.get 20
                  i32.const -4
                  i32.add
                  local.tee 20
                  i32.const 0
                  i32.store
                end
                local.get 13
                local.get 13
                i32.load
                i32.const 1
                i32.add
                local.tee 12
                i32.store
                local.get 12
                i32.const 999999999
                i32.gt_u
                br_if 0 (;@6;)
              end
            end
            local.get 18
            local.get 20
            i32.sub
            i32.const 2
            i32.shr_s
            i32.const 9
            i32.mul
            local.set 19
            i32.const 10
            local.set 12
            local.get 20
            i32.load
            local.tee 3
            i32.const 10
            i32.lt_u
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 19
              i32.const 1
              i32.add
              local.set 19
              local.get 3
              local.get 12
              i32.const 10
              i32.mul
              local.tee 12
              i32.ge_u
              br_if 0 (;@5;)
            end
          end
          local.get 13
          i32.const 4
          i32.add
          local.tee 12
          local.get 11
          local.get 11
          local.get 12
          i32.gt_u
          select
          local.set 11
        end
        block  ;; label = @3
          loop  ;; label = @4
            local.get 11
            local.tee 12
            local.get 20
            i32.le_u
            local.tee 3
            br_if 1 (;@3;)
            local.get 12
            i32.const -4
            i32.add
            local.tee 11
            i32.load
            i32.eqz
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 15
            i32.const 103
            i32.eq
            br_if 0 (;@4;)
            local.get 4
            i32.const 8
            i32.and
            local.set 25
            br 1 (;@3;)
          end
          local.get 19
          i32.const -1
          i32.xor
          i32.const -1
          local.get 16
          i32.const 1
          local.get 16
          select
          local.tee 11
          local.get 19
          i32.gt_s
          local.get 19
          i32.const -5
          i32.gt_s
          i32.and
          local.tee 13
          select
          local.get 11
          i32.add
          local.set 16
          i32.const -1
          i32.const -2
          local.get 13
          select
          local.get 5
          i32.add
          local.set 5
          local.get 4
          i32.const 8
          i32.and
          local.tee 25
          br_if 0 (;@3;)
          i32.const -9
          local.set 11
          block  ;; label = @4
            local.get 3
            br_if 0 (;@4;)
            local.get 12
            i32.const -4
            i32.add
            i32.load
            local.tee 13
            i32.eqz
            br_if 0 (;@4;)
            i32.const 10
            local.set 3
            i32.const 0
            local.set 11
            local.get 13
            i32.const 10
            i32.rem_u
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 11
              local.tee 25
              i32.const 1
              i32.add
              local.set 11
              local.get 13
              local.get 3
              i32.const 10
              i32.mul
              local.tee 3
              i32.rem_u
              i32.eqz
              br_if 0 (;@5;)
            end
            local.get 25
            i32.const -1
            i32.xor
            local.set 11
          end
          local.get 12
          local.get 18
          i32.sub
          i32.const 2
          i32.shr_s
          i32.const 9
          i32.mul
          local.set 3
          block  ;; label = @4
            local.get 5
            i32.const -33
            i32.and
            i32.const 70
            i32.ne
            br_if 0 (;@4;)
            i32.const 0
            local.set 25
            local.get 16
            local.get 3
            local.get 11
            i32.add
            i32.const -9
            i32.add
            local.tee 11
            i32.const 0
            local.get 11
            i32.const 0
            i32.gt_s
            select
            local.tee 11
            local.get 16
            local.get 11
            i32.lt_s
            select
            local.set 16
            br 1 (;@3;)
          end
          i32.const 0
          local.set 25
          local.get 16
          local.get 19
          local.get 3
          i32.add
          local.get 11
          i32.add
          i32.const -9
          i32.add
          local.tee 11
          i32.const 0
          local.get 11
          i32.const 0
          i32.gt_s
          select
          local.tee 11
          local.get 16
          local.get 11
          i32.lt_s
          select
          local.set 16
        end
        i32.const -1
        local.set 13
        local.get 16
        i32.const 2147483645
        i32.const 2147483646
        local.get 16
        local.get 25
        i32.or
        local.tee 26
        select
        i32.gt_s
        br_if 1 (;@1;)
        local.get 16
        local.get 26
        i32.const 0
        i32.ne
        i32.add
        i32.const 1
        i32.add
        local.set 3
        block  ;; label = @3
          block  ;; label = @4
            local.get 5
            i32.const -33
            i32.and
            local.tee 24
            i32.const 70
            i32.ne
            br_if 0 (;@4;)
            local.get 19
            local.get 3
            i32.const 2147483647
            i32.xor
            i32.gt_s
            br_if 3 (;@1;)
            local.get 19
            i32.const 0
            local.get 19
            i32.const 0
            i32.gt_s
            select
            local.set 11
            br 1 (;@3;)
          end
          block  ;; label = @4
            local.get 14
            local.get 19
            local.get 19
            i32.const 31
            i32.shr_s
            local.tee 11
            i32.xor
            local.get 11
            i32.sub
            i64.extend_i32_u
            local.get 14
            call $fmt_u
            local.tee 11
            i32.sub
            i32.const 1
            i32.gt_s
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 11
              i32.const -1
              i32.add
              local.tee 11
              i32.const 48
              i32.store8
              local.get 14
              local.get 11
              i32.sub
              i32.const 2
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          local.get 11
          i32.const -2
          i32.add
          local.tee 23
          local.get 5
          i32.store8
          i32.const -1
          local.set 13
          local.get 11
          i32.const -1
          i32.add
          i32.const 45
          i32.const 43
          local.get 19
          i32.const 0
          i32.lt_s
          select
          i32.store8
          local.get 14
          local.get 23
          i32.sub
          local.tee 11
          local.get 3
          i32.const 2147483647
          i32.xor
          i32.gt_s
          br_if 2 (;@1;)
        end
        i32.const -1
        local.set 13
        local.get 11
        local.get 3
        i32.add
        local.tee 11
        local.get 9
        i32.const 2147483647
        i32.xor
        i32.gt_s
        br_if 1 (;@1;)
        local.get 0
        i32.const 32
        local.get 2
        local.get 11
        local.get 9
        i32.add
        local.tee 5
        local.get 4
        call $pad
        local.get 0
        local.get 10
        local.get 9
        call $out
        local.get 0
        i32.const 48
        local.get 2
        local.get 5
        local.get 4
        i32.const 65536
        i32.xor
        call $pad
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 24
                i32.const 70
                i32.ne
                br_if 0 (;@6;)
                local.get 6
                i32.const 16
                i32.add
                i32.const 9
                i32.or
                local.set 19
                local.get 18
                local.get 20
                local.get 20
                local.get 18
                i32.gt_u
                select
                local.tee 3
                local.set 20
                loop  ;; label = @7
                  local.get 20
                  i64.load32_u
                  local.get 19
                  call $fmt_u
                  local.set 11
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 20
                      local.get 3
                      i32.eq
                      br_if 0 (;@9;)
                      local.get 11
                      local.get 6
                      i32.const 16
                      i32.add
                      i32.le_u
                      br_if 1 (;@8;)
                      loop  ;; label = @10
                        local.get 11
                        i32.const -1
                        i32.add
                        local.tee 11
                        i32.const 48
                        i32.store8
                        local.get 11
                        local.get 6
                        i32.const 16
                        i32.add
                        i32.gt_u
                        br_if 0 (;@10;)
                        br 2 (;@8;)
                      end
                    end
                    local.get 11
                    local.get 19
                    i32.ne
                    br_if 0 (;@8;)
                    local.get 11
                    i32.const -1
                    i32.add
                    local.tee 11
                    i32.const 48
                    i32.store8
                  end
                  local.get 0
                  local.get 11
                  local.get 19
                  local.get 11
                  i32.sub
                  call $out
                  local.get 20
                  i32.const 4
                  i32.add
                  local.tee 20
                  local.get 18
                  i32.le_u
                  br_if 0 (;@7;)
                end
                block  ;; label = @7
                  local.get 26
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 0
                  i32.const 65640
                  i32.const 1
                  call $out
                end
                local.get 20
                local.get 12
                i32.ge_u
                br_if 1 (;@5;)
                local.get 16
                i32.const 1
                i32.lt_s
                br_if 1 (;@5;)
                loop  ;; label = @7
                  block  ;; label = @8
                    local.get 20
                    i64.load32_u
                    local.get 19
                    call $fmt_u
                    local.tee 11
                    local.get 6
                    i32.const 16
                    i32.add
                    i32.le_u
                    br_if 0 (;@8;)
                    loop  ;; label = @9
                      local.get 11
                      i32.const -1
                      i32.add
                      local.tee 11
                      i32.const 48
                      i32.store8
                      local.get 11
                      local.get 6
                      i32.const 16
                      i32.add
                      i32.gt_u
                      br_if 0 (;@9;)
                    end
                  end
                  local.get 0
                  local.get 11
                  local.get 16
                  i32.const 9
                  local.get 16
                  i32.const 9
                  i32.lt_s
                  select
                  call $out
                  local.get 16
                  i32.const -9
                  i32.add
                  local.set 11
                  local.get 20
                  i32.const 4
                  i32.add
                  local.tee 20
                  local.get 12
                  i32.ge_u
                  br_if 3 (;@4;)
                  local.get 16
                  i32.const 9
                  i32.gt_s
                  local.set 3
                  local.get 11
                  local.set 16
                  local.get 3
                  br_if 0 (;@7;)
                  br 3 (;@4;)
                end
              end
              block  ;; label = @6
                local.get 16
                i32.const 0
                i32.lt_s
                br_if 0 (;@6;)
                local.get 12
                local.get 20
                i32.const 4
                i32.add
                local.get 12
                local.get 20
                i32.gt_u
                select
                local.set 13
                local.get 6
                i32.const 16
                i32.add
                i32.const 9
                i32.or
                local.set 19
                local.get 20
                local.set 12
                loop  ;; label = @7
                  block  ;; label = @8
                    local.get 12
                    i64.load32_u
                    local.get 19
                    call $fmt_u
                    local.tee 11
                    local.get 19
                    i32.ne
                    br_if 0 (;@8;)
                    local.get 11
                    i32.const -1
                    i32.add
                    local.tee 11
                    i32.const 48
                    i32.store8
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 12
                      local.get 20
                      i32.eq
                      br_if 0 (;@9;)
                      local.get 11
                      local.get 6
                      i32.const 16
                      i32.add
                      i32.le_u
                      br_if 1 (;@8;)
                      loop  ;; label = @10
                        local.get 11
                        i32.const -1
                        i32.add
                        local.tee 11
                        i32.const 48
                        i32.store8
                        local.get 11
                        local.get 6
                        i32.const 16
                        i32.add
                        i32.gt_u
                        br_if 0 (;@10;)
                        br 2 (;@8;)
                      end
                    end
                    local.get 0
                    local.get 11
                    i32.const 1
                    call $out
                    local.get 11
                    i32.const 1
                    i32.add
                    local.set 11
                    local.get 16
                    local.get 25
                    i32.or
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 0
                    i32.const 65640
                    i32.const 1
                    call $out
                  end
                  local.get 0
                  local.get 11
                  local.get 19
                  local.get 11
                  i32.sub
                  local.tee 3
                  local.get 16
                  local.get 16
                  local.get 3
                  i32.gt_s
                  select
                  call $out
                  local.get 16
                  local.get 3
                  i32.sub
                  local.set 16
                  local.get 12
                  i32.const 4
                  i32.add
                  local.tee 12
                  local.get 13
                  i32.ge_u
                  br_if 1 (;@6;)
                  local.get 16
                  i32.const -1
                  i32.gt_s
                  br_if 0 (;@7;)
                end
              end
              local.get 0
              i32.const 48
              local.get 16
              i32.const 18
              i32.add
              i32.const 18
              i32.const 0
              call $pad
              local.get 0
              local.get 23
              local.get 14
              local.get 23
              i32.sub
              call $out
              br 2 (;@3;)
            end
            local.get 16
            local.set 11
          end
          local.get 0
          i32.const 48
          local.get 11
          i32.const 9
          i32.add
          i32.const 9
          i32.const 0
          call $pad
        end
        local.get 0
        i32.const 32
        local.get 2
        local.get 5
        local.get 4
        i32.const 8192
        i32.xor
        call $pad
        local.get 2
        local.get 5
        local.get 2
        local.get 5
        i32.gt_s
        select
        local.set 13
        br 1 (;@1;)
      end
      local.get 10
      local.get 5
      i32.const 26
      i32.shl
      i32.const 31
      i32.shr_s
      i32.const 9
      i32.and
      i32.add
      local.set 23
      block  ;; label = @2
        local.get 3
        i32.const 11
        i32.gt_u
        br_if 0 (;@2;)
        i32.const 12
        local.get 3
        i32.sub
        local.set 11
        f64.const 0x1p+4 (;=16;)
        local.set 27
        loop  ;; label = @3
          local.get 27
          f64.const 0x1p+4 (;=16;)
          f64.mul
          local.set 27
          local.get 11
          i32.const -1
          i32.add
          local.tee 11
          br_if 0 (;@3;)
        end
        block  ;; label = @3
          local.get 23
          i32.load8_u
          i32.const 45
          i32.ne
          br_if 0 (;@3;)
          local.get 27
          local.get 1
          f64.neg
          local.get 27
          f64.sub
          f64.add
          f64.neg
          local.set 1
          br 1 (;@2;)
        end
        local.get 1
        local.get 27
        f64.add
        local.get 27
        f64.sub
        local.set 1
      end
      block  ;; label = @2
        local.get 6
        i32.load offset=44
        local.tee 12
        local.get 12
        i32.const 31
        i32.shr_s
        local.tee 11
        i32.xor
        local.get 11
        i32.sub
        i64.extend_i32_u
        local.get 14
        call $fmt_u
        local.tee 11
        local.get 14
        i32.ne
        br_if 0 (;@2;)
        local.get 11
        i32.const -1
        i32.add
        local.tee 11
        i32.const 48
        i32.store8
        local.get 6
        i32.load offset=44
        local.set 12
      end
      local.get 9
      i32.const 2
      i32.or
      local.set 25
      local.get 5
      i32.const 32
      i32.and
      local.set 20
      local.get 11
      i32.const -2
      i32.add
      local.tee 26
      local.get 5
      i32.const 15
      i32.add
      i32.store8
      local.get 11
      i32.const -1
      i32.add
      i32.const 45
      i32.const 43
      local.get 12
      i32.const 0
      i32.lt_s
      select
      i32.store8
      local.get 3
      i32.const 1
      i32.lt_s
      local.get 4
      i32.const 8
      i32.and
      i32.eqz
      i32.and
      local.set 19
      local.get 6
      i32.const 16
      i32.add
      local.set 12
      loop  ;; label = @2
        local.get 12
        local.tee 11
        local.get 1
        i32.trunc_sat_f64_s
        local.tee 12
        i32.const 72448
        i32.add
        i32.load8_u
        local.get 20
        i32.or
        i32.store8
        local.get 1
        local.get 12
        f64.convert_i32_s
        f64.sub
        f64.const 0x1p+4 (;=16;)
        f64.mul
        local.set 1
        block  ;; label = @3
          local.get 11
          i32.const 1
          i32.add
          local.tee 12
          local.get 6
          i32.const 16
          i32.add
          i32.sub
          i32.const 1
          i32.ne
          br_if 0 (;@3;)
          local.get 1
          f64.const 0x0p+0 (;=0;)
          f64.eq
          local.get 19
          i32.and
          br_if 0 (;@3;)
          local.get 11
          i32.const 46
          i32.store8 offset=1
          local.get 11
          i32.const 2
          i32.add
          local.set 12
        end
        local.get 1
        f64.const 0x0p+0 (;=0;)
        f64.ne
        br_if 0 (;@2;)
      end
      i32.const -1
      local.set 13
      local.get 3
      i32.const 2147483645
      local.get 25
      local.get 14
      local.get 26
      i32.sub
      local.tee 20
      i32.add
      local.tee 19
      i32.sub
      i32.gt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 32
      local.get 2
      local.get 19
      local.get 3
      i32.const 2
      i32.add
      local.get 12
      local.get 6
      i32.const 16
      i32.add
      i32.sub
      local.tee 11
      local.get 11
      i32.const -2
      i32.add
      local.get 3
      i32.lt_s
      select
      local.get 11
      local.get 3
      select
      local.tee 3
      i32.add
      local.tee 12
      local.get 4
      call $pad
      local.get 0
      local.get 23
      local.get 25
      call $out
      local.get 0
      i32.const 48
      local.get 2
      local.get 12
      local.get 4
      i32.const 65536
      i32.xor
      call $pad
      local.get 0
      local.get 6
      i32.const 16
      i32.add
      local.get 11
      call $out
      local.get 0
      i32.const 48
      local.get 3
      local.get 11
      i32.sub
      i32.const 0
      i32.const 0
      call $pad
      local.get 0
      local.get 26
      local.get 20
      call $out
      local.get 0
      i32.const 32
      local.get 2
      local.get 12
      local.get 4
      i32.const 8192
      i32.xor
      call $pad
      local.get 2
      local.get 12
      local.get 2
      local.get 12
      i32.gt_s
      select
      local.set 13
    end
    local.get 6
    i32.const 560
    i32.add
    global.set $__stack_pointer
    local.get 13)
  (func $pop_arg_long_double (type 4) (param i32 i32)
    (local i32)
    local.get 1
    local.get 1
    i32.load
    i32.const 7
    i32.add
    i32.const -8
    i32.and
    local.tee 2
    i32.const 16
    i32.add
    i32.store
    local.get 0
    local.get 2
    i64.load
    local.get 2
    i64.load offset=8
    call $__trunctfdf2
    f64.store)
  (func $__DOUBLE_BITS (type 29) (param f64) (result i64)
    local.get 0
    i64.reinterpret_f64)
  (func $vsnprintf (type 0) (param i32 i32 i32 i32) (result i32)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 160
    i32.sub
    local.tee 4
    global.set $__stack_pointer
    local.get 4
    local.get 0
    local.get 4
    i32.const 158
    i32.add
    local.get 1
    select
    local.tee 0
    i32.store offset=148
    local.get 4
    i32.const 0
    local.get 1
    i32.const -1
    i32.add
    local.tee 5
    local.get 5
    local.get 1
    i32.gt_u
    select
    i32.store offset=152
    block  ;; label = @1
      i32.const 144
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      i32.const 0
      i32.const 144
      memory.fill
    end
    local.get 4
    i32.const -1
    i32.store offset=76
    local.get 4
    i32.const 3
    i32.store offset=36
    local.get 4
    i32.const -1
    i32.store offset=80
    local.get 4
    local.get 4
    i32.const 159
    i32.add
    i32.store offset=44
    local.get 4
    local.get 4
    i32.const 148
    i32.add
    i32.store offset=84
    local.get 0
    i32.const 0
    i32.store8
    local.get 4
    local.get 2
    local.get 3
    call $vfprintf
    local.set 1
    local.get 4
    i32.const 160
    i32.add
    global.set $__stack_pointer
    local.get 1)
  (func $sn_write (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    local.get 0
    i32.load offset=84
    local.tee 3
    i32.load
    local.set 4
    block  ;; label = @1
      local.get 3
      i32.load offset=4
      local.tee 5
      local.get 0
      i32.load offset=20
      local.get 0
      i32.load offset=28
      local.tee 6
      i32.sub
      local.tee 7
      local.get 5
      local.get 7
      i32.lt_u
      select
      local.tee 7
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      local.get 6
      local.get 7
      call $__memcpy
      drop
      local.get 3
      local.get 3
      i32.load
      local.get 7
      i32.add
      local.tee 4
      i32.store
      local.get 3
      local.get 3
      i32.load offset=4
      local.get 7
      i32.sub
      local.tee 5
      i32.store offset=4
    end
    block  ;; label = @1
      local.get 5
      local.get 2
      local.get 5
      local.get 2
      i32.lt_u
      select
      local.tee 5
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      local.get 1
      local.get 5
      call $__memcpy
      drop
      local.get 3
      local.get 3
      i32.load
      local.get 5
      i32.add
      local.tee 4
      i32.store
      local.get 3
      local.get 3
      i32.load offset=4
      local.get 5
      i32.sub
      i32.store offset=4
    end
    local.get 4
    i32.const 0
    i32.store8
    local.get 0
    local.get 0
    i32.load offset=44
    local.tee 3
    i32.store offset=28
    local.get 0
    local.get 3
    i32.store offset=20
    local.get 2)
  (func $__syscall_getpid (type 20) (result i32)
    i32.const 42)
  (func $getpid (type 20) (result i32)
    call $__syscall_getpid)
  (func $__get_tp (type 20) (result i32)
    i32.const 75216)
  (func $init_pthread_self (type 7)
    (local i32)
    i32.const 0
    i32.const 75192
    i32.store offset=75312
    call $getpid
    local.set 0
    i32.const 0
    i32.const 65536
    i32.const 0
    i32.sub
    i32.store offset=75272
    i32.const 0
    i32.const 65536
    i32.store offset=75268
    i32.const 0
    local.get 0
    i32.store offset=75240
    i32.const 0
    i32.const 0
    i32.load offset=74696
    i32.store offset=75276)
  (func $wcrtomb (type 2) (param i32 i32 i32) (result i32)
    (local i32)
    i32.const 1
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        i32.const 127
        i32.le_u
        br_if 1 (;@1;)
        block  ;; label = @3
          block  ;; label = @4
            call $__get_tp
            i32.load offset=96
            i32.load
            br_if 0 (;@4;)
            local.get 1
            i32.const -128
            i32.and
            i32.const 57216
            i32.eq
            br_if 3 (;@1;)
            call $__errno_location
            i32.const 25
            i32.store
            br 1 (;@3;)
          end
          block  ;; label = @4
            local.get 1
            i32.const 2047
            i32.gt_u
            br_if 0 (;@4;)
            local.get 0
            local.get 1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=1
            local.get 0
            local.get 1
            i32.const 6
            i32.shr_u
            i32.const 192
            i32.or
            i32.store8
            i32.const 2
            return
          end
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.const 55296
              i32.lt_u
              br_if 0 (;@5;)
              local.get 1
              i32.const -8192
              i32.and
              i32.const 57344
              i32.ne
              br_if 1 (;@4;)
            end
            local.get 0
            local.get 1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=2
            local.get 0
            local.get 1
            i32.const 12
            i32.shr_u
            i32.const 224
            i32.or
            i32.store8
            local.get 0
            local.get 1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=1
            i32.const 3
            return
          end
          block  ;; label = @4
            local.get 1
            i32.const -65536
            i32.add
            i32.const 1048575
            i32.gt_u
            br_if 0 (;@4;)
            local.get 0
            local.get 1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=3
            local.get 0
            local.get 1
            i32.const 18
            i32.shr_u
            i32.const 240
            i32.or
            i32.store8
            local.get 0
            local.get 1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=2
            local.get 0
            local.get 1
            i32.const 12
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=1
            i32.const 4
            return
          end
          call $__errno_location
          i32.const 25
          i32.store
        end
        i32.const -1
        local.set 3
      end
      local.get 3
      return
    end
    local.get 0
    local.get 1
    i32.store8
    i32.const 1)
  (func $wctomb (type 6) (param i32 i32) (result i32)
    block  ;; label = @1
      local.get 0
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 0
    local.get 1
    i32.const 0
    call $wcrtomb)
  (func $abort (type 7)
    call $_abort_js
    unreachable)
  (func $__wasi_syscall_ret (type 8) (param i32) (result i32)
    block  ;; label = @1
      local.get 0
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    call $__errno_location
    local.get 0
    i32.store
    i32.const -1)
  (func $dummy (type 8) (param i32) (result i32)
    local.get 0)
  (func $__stdio_close (type 8) (param i32) (result i32)
    local.get 0
    i32.load offset=60
    call $dummy
    call $__wasi_fd_close
    call $__wasi_syscall_ret)
  (func $__stdio_write (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    local.get 3
    local.get 0
    i32.load offset=28
    local.tee 4
    i32.store offset=16
    local.get 0
    i32.load offset=20
    local.set 5
    local.get 3
    local.get 2
    i32.store offset=28
    local.get 3
    local.get 1
    i32.store offset=24
    local.get 3
    local.get 5
    local.get 4
    i32.sub
    local.tee 1
    i32.store offset=20
    local.get 1
    local.get 2
    i32.add
    local.set 6
    local.get 3
    i32.const 16
    i32.add
    local.set 4
    i32.const 2
    local.set 7
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.load offset=60
              local.get 3
              i32.const 16
              i32.add
              i32.const 2
              local.get 3
              i32.const 12
              i32.add
              call $__wasi_fd_write
              call $__wasi_syscall_ret
              i32.eqz
              br_if 0 (;@5;)
              local.get 4
              local.set 5
              br 1 (;@4;)
            end
            loop  ;; label = @5
              local.get 6
              local.get 3
              i32.load offset=12
              local.tee 1
              i32.eq
              br_if 2 (;@3;)
              block  ;; label = @6
                local.get 1
                i32.const -1
                i32.gt_s
                br_if 0 (;@6;)
                local.get 4
                local.set 5
                br 4 (;@2;)
              end
              local.get 4
              i32.const 8
              i32.const 0
              local.get 1
              local.get 4
              i32.load offset=4
              local.tee 8
              i32.gt_u
              local.tee 9
              select
              i32.add
              local.tee 5
              local.get 5
              i32.load
              local.get 1
              local.get 8
              i32.const 0
              local.get 9
              select
              i32.sub
              local.tee 8
              i32.add
              i32.store
              local.get 4
              i32.const 12
              i32.const 4
              local.get 9
              select
              i32.add
              local.tee 4
              local.get 4
              i32.load
              local.get 8
              i32.sub
              i32.store
              local.get 6
              local.get 1
              i32.sub
              local.set 6
              local.get 5
              local.set 4
              local.get 0
              i32.load offset=60
              local.get 5
              local.get 7
              local.get 9
              i32.sub
              local.tee 7
              local.get 3
              i32.const 12
              i32.add
              call $__wasi_fd_write
              call $__wasi_syscall_ret
              i32.eqz
              br_if 0 (;@5;)
            end
          end
          local.get 6
          i32.const -1
          i32.ne
          br_if 1 (;@2;)
        end
        local.get 0
        local.get 0
        i32.load offset=44
        local.tee 1
        i32.store offset=28
        local.get 0
        local.get 1
        i32.store offset=20
        local.get 0
        local.get 1
        local.get 0
        i32.load offset=48
        i32.add
        i32.store offset=16
        local.get 2
        local.set 1
        br 1 (;@1;)
      end
      i32.const 0
      local.set 1
      local.get 0
      i32.const 0
      i32.store offset=28
      local.get 0
      i64.const 0
      i64.store offset=16
      local.get 0
      local.get 0
      i32.load
      i32.const 32
      i32.or
      i32.store
      local.get 7
      i32.const 2
      i32.eq
      br_if 0 (;@1;)
      local.get 2
      local.get 5
      i32.load offset=4
      i32.sub
      local.set 1
    end
    local.get 3
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get 1)
  (func $__lseek (type 5) (param i32 i64 i32) (result i64)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 3
    global.set $__stack_pointer
    local.get 0
    local.get 1
    local.get 2
    i32.const 255
    i32.and
    local.get 3
    i32.const 8
    i32.add
    call $__wasi_fd_seek
    call $__wasi_syscall_ret
    local.set 2
    local.get 3
    i64.load offset=8
    local.set 1
    local.get 3
    i32.const 16
    i32.add
    global.set $__stack_pointer
    i64.const -1
    local.get 1
    local.get 2
    select)
  (func $__stdio_seek (type 5) (param i32 i64 i32) (result i64)
    local.get 0
    i32.load offset=60
    local.get 1
    local.get 2
    call $__lseek)
  (func $emscripten_builtin_malloc (type 8) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.const 244
              i32.gt_u
              br_if 0 (;@5;)
              block  ;; label = @6
                i32.const 0
                i32.load offset=75356
                local.tee 2
                i32.const 16
                local.get 0
                i32.const 11
                i32.add
                i32.const 504
                i32.and
                local.get 0
                i32.const 11
                i32.lt_u
                select
                local.tee 3
                i32.const 3
                i32.shr_u
                local.tee 4
                i32.shr_u
                local.tee 0
                i32.const 3
                i32.and
                i32.eqz
                br_if 0 (;@6;)
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 0
                    i32.const -1
                    i32.xor
                    i32.const 1
                    i32.and
                    local.get 4
                    i32.add
                    local.tee 3
                    i32.const 3
                    i32.shl
                    local.tee 0
                    i32.const 75396
                    i32.add
                    local.tee 5
                    local.get 0
                    i32.const 75404
                    i32.add
                    i32.load
                    local.tee 4
                    i32.load offset=8
                    local.tee 0
                    i32.ne
                    br_if 0 (;@8;)
                    i32.const 0
                    local.get 2
                    i32.const -2
                    local.get 3
                    i32.rotl
                    i32.and
                    i32.store offset=75356
                    br 1 (;@7;)
                  end
                  local.get 0
                  i32.const 0
                  i32.load offset=75372
                  i32.lt_u
                  br_if 4 (;@3;)
                  local.get 0
                  i32.load offset=12
                  local.get 4
                  i32.ne
                  br_if 4 (;@3;)
                  local.get 0
                  local.get 5
                  i32.store offset=12
                  local.get 5
                  local.get 0
                  i32.store offset=8
                end
                local.get 4
                i32.const 8
                i32.add
                local.set 0
                local.get 4
                local.get 3
                i32.const 3
                i32.shl
                local.tee 3
                i32.const 3
                i32.or
                i32.store offset=4
                local.get 4
                local.get 3
                i32.add
                local.tee 4
                local.get 4
                i32.load offset=4
                i32.const 1
                i32.or
                i32.store offset=4
                br 5 (;@1;)
              end
              local.get 3
              i32.const 0
              i32.load offset=75364
              local.tee 6
              i32.le_u
              br_if 1 (;@4;)
              block  ;; label = @6
                local.get 0
                i32.eqz
                br_if 0 (;@6;)
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 0
                    local.get 4
                    i32.shl
                    i32.const 2
                    local.get 4
                    i32.shl
                    local.tee 0
                    i32.const 0
                    local.get 0
                    i32.sub
                    i32.or
                    i32.and
                    i32.ctz
                    local.tee 5
                    i32.const 3
                    i32.shl
                    local.tee 0
                    i32.const 75396
                    i32.add
                    local.tee 7
                    local.get 0
                    i32.const 75404
                    i32.add
                    i32.load
                    local.tee 0
                    i32.load offset=8
                    local.tee 4
                    i32.ne
                    br_if 0 (;@8;)
                    i32.const 0
                    local.get 2
                    i32.const -2
                    local.get 5
                    i32.rotl
                    i32.and
                    local.tee 2
                    i32.store offset=75356
                    br 1 (;@7;)
                  end
                  local.get 4
                  i32.const 0
                  i32.load offset=75372
                  i32.lt_u
                  br_if 4 (;@3;)
                  local.get 4
                  i32.load offset=12
                  local.get 0
                  i32.ne
                  br_if 4 (;@3;)
                  local.get 4
                  local.get 7
                  i32.store offset=12
                  local.get 7
                  local.get 4
                  i32.store offset=8
                end
                local.get 0
                local.get 3
                i32.const 3
                i32.or
                i32.store offset=4
                local.get 0
                local.get 3
                i32.add
                local.tee 7
                local.get 5
                i32.const 3
                i32.shl
                local.tee 4
                local.get 3
                i32.sub
                local.tee 3
                i32.const 1
                i32.or
                i32.store offset=4
                local.get 0
                local.get 4
                i32.add
                local.get 3
                i32.store
                block  ;; label = @7
                  local.get 6
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 6
                  i32.const -8
                  i32.and
                  i32.const 75396
                  i32.add
                  local.set 5
                  i32.const 0
                  i32.load offset=75376
                  local.set 4
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 2
                      i32.const 1
                      local.get 6
                      i32.const 3
                      i32.shr_u
                      i32.shl
                      local.tee 8
                      i32.and
                      br_if 0 (;@9;)
                      i32.const 0
                      local.get 2
                      local.get 8
                      i32.or
                      i32.store offset=75356
                      local.get 5
                      local.set 8
                      br 1 (;@8;)
                    end
                    local.get 5
                    i32.load offset=8
                    local.tee 8
                    i32.const 0
                    i32.load offset=75372
                    i32.lt_u
                    br_if 5 (;@3;)
                  end
                  local.get 5
                  local.get 4
                  i32.store offset=8
                  local.get 8
                  local.get 4
                  i32.store offset=12
                  local.get 4
                  local.get 5
                  i32.store offset=12
                  local.get 4
                  local.get 8
                  i32.store offset=8
                end
                local.get 0
                i32.const 8
                i32.add
                local.set 0
                i32.const 0
                local.get 7
                i32.store offset=75376
                i32.const 0
                local.get 3
                i32.store offset=75364
                br 5 (;@1;)
              end
              i32.const 0
              i32.load offset=75360
              local.tee 9
              i32.eqz
              br_if 1 (;@4;)
              local.get 9
              i32.ctz
              i32.const 2
              i32.shl
              i32.const 75660
              i32.add
              i32.load
              local.tee 7
              i32.load offset=4
              i32.const -8
              i32.and
              local.get 3
              i32.sub
              local.set 4
              local.get 7
              local.set 5
              block  ;; label = @6
                loop  ;; label = @7
                  block  ;; label = @8
                    local.get 5
                    i32.load offset=16
                    local.tee 0
                    br_if 0 (;@8;)
                    local.get 5
                    i32.load offset=20
                    local.tee 0
                    i32.eqz
                    br_if 2 (;@6;)
                  end
                  local.get 0
                  i32.load offset=4
                  i32.const -8
                  i32.and
                  local.get 3
                  i32.sub
                  local.tee 5
                  local.get 4
                  local.get 5
                  local.get 4
                  i32.lt_u
                  local.tee 5
                  select
                  local.set 4
                  local.get 0
                  local.get 7
                  local.get 5
                  select
                  local.set 7
                  local.get 0
                  local.set 5
                  br 0 (;@7;)
                end
              end
              local.get 7
              i32.const 0
              i32.load offset=75372
              local.tee 10
              i32.lt_u
              br_if 2 (;@3;)
              local.get 7
              i32.load offset=24
              local.set 11
              block  ;; label = @6
                block  ;; label = @7
                  local.get 7
                  i32.load offset=12
                  local.tee 0
                  local.get 7
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 7
                  i32.load offset=8
                  local.tee 5
                  local.get 10
                  i32.lt_u
                  br_if 4 (;@3;)
                  local.get 5
                  i32.load offset=12
                  local.get 7
                  i32.ne
                  br_if 4 (;@3;)
                  local.get 0
                  i32.load offset=8
                  local.get 7
                  i32.ne
                  br_if 4 (;@3;)
                  local.get 5
                  local.get 0
                  i32.store offset=12
                  local.get 0
                  local.get 5
                  i32.store offset=8
                  br 1 (;@6;)
                end
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 7
                      i32.load offset=20
                      local.tee 5
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 7
                      i32.const 20
                      i32.add
                      local.set 8
                      br 1 (;@8;)
                    end
                    local.get 7
                    i32.load offset=16
                    local.tee 5
                    i32.eqz
                    br_if 1 (;@7;)
                    local.get 7
                    i32.const 16
                    i32.add
                    local.set 8
                  end
                  loop  ;; label = @8
                    local.get 8
                    local.set 12
                    local.get 5
                    local.tee 0
                    i32.const 20
                    i32.add
                    local.set 8
                    local.get 0
                    i32.load offset=20
                    local.tee 5
                    br_if 0 (;@8;)
                    local.get 0
                    i32.const 16
                    i32.add
                    local.set 8
                    local.get 0
                    i32.load offset=16
                    local.tee 5
                    br_if 0 (;@8;)
                  end
                  local.get 12
                  local.get 10
                  i32.lt_u
                  br_if 4 (;@3;)
                  local.get 12
                  i32.const 0
                  i32.store
                  br 1 (;@6;)
                end
                i32.const 0
                local.set 0
              end
              block  ;; label = @6
                local.get 11
                i32.eqz
                br_if 0 (;@6;)
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 7
                    local.get 7
                    i32.load offset=28
                    local.tee 8
                    i32.const 2
                    i32.shl
                    i32.const 75660
                    i32.add
                    local.tee 5
                    i32.load
                    i32.ne
                    br_if 0 (;@8;)
                    local.get 5
                    local.get 0
                    i32.store
                    local.get 0
                    br_if 1 (;@7;)
                    i32.const 0
                    local.get 9
                    i32.const -2
                    local.get 8
                    i32.rotl
                    i32.and
                    i32.store offset=75360
                    br 2 (;@6;)
                  end
                  local.get 11
                  local.get 10
                  i32.lt_u
                  br_if 4 (;@3;)
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 11
                      i32.load offset=16
                      local.get 7
                      i32.ne
                      br_if 0 (;@9;)
                      local.get 11
                      local.get 0
                      i32.store offset=16
                      br 1 (;@8;)
                    end
                    local.get 11
                    local.get 0
                    i32.store offset=20
                  end
                  local.get 0
                  i32.eqz
                  br_if 1 (;@6;)
                end
                local.get 0
                local.get 10
                i32.lt_u
                br_if 3 (;@3;)
                local.get 0
                local.get 11
                i32.store offset=24
                block  ;; label = @7
                  local.get 7
                  i32.load offset=16
                  local.tee 5
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 5
                  local.get 10
                  i32.lt_u
                  br_if 4 (;@3;)
                  local.get 0
                  local.get 5
                  i32.store offset=16
                  local.get 5
                  local.get 0
                  i32.store offset=24
                end
                local.get 7
                i32.load offset=20
                local.tee 5
                i32.eqz
                br_if 0 (;@6;)
                local.get 5
                local.get 10
                i32.lt_u
                br_if 3 (;@3;)
                local.get 0
                local.get 5
                i32.store offset=20
                local.get 5
                local.get 0
                i32.store offset=24
              end
              block  ;; label = @6
                block  ;; label = @7
                  local.get 4
                  i32.const 15
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 7
                  local.get 4
                  local.get 3
                  i32.add
                  local.tee 0
                  i32.const 3
                  i32.or
                  i32.store offset=4
                  local.get 7
                  local.get 0
                  i32.add
                  local.tee 0
                  local.get 0
                  i32.load offset=4
                  i32.const 1
                  i32.or
                  i32.store offset=4
                  br 1 (;@6;)
                end
                local.get 7
                local.get 3
                i32.const 3
                i32.or
                i32.store offset=4
                local.get 7
                local.get 3
                i32.add
                local.tee 3
                local.get 4
                i32.const 1
                i32.or
                i32.store offset=4
                local.get 3
                local.get 4
                i32.add
                local.get 4
                i32.store
                block  ;; label = @7
                  local.get 6
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 6
                  i32.const -8
                  i32.and
                  i32.const 75396
                  i32.add
                  local.set 5
                  i32.const 0
                  i32.load offset=75376
                  local.set 0
                  block  ;; label = @8
                    block  ;; label = @9
                      i32.const 1
                      local.get 6
                      i32.const 3
                      i32.shr_u
                      i32.shl
                      local.tee 8
                      local.get 2
                      i32.and
                      br_if 0 (;@9;)
                      i32.const 0
                      local.get 8
                      local.get 2
                      i32.or
                      i32.store offset=75356
                      local.get 5
                      local.set 8
                      br 1 (;@8;)
                    end
                    local.get 5
                    i32.load offset=8
                    local.tee 8
                    local.get 10
                    i32.lt_u
                    br_if 5 (;@3;)
                  end
                  local.get 5
                  local.get 0
                  i32.store offset=8
                  local.get 8
                  local.get 0
                  i32.store offset=12
                  local.get 0
                  local.get 5
                  i32.store offset=12
                  local.get 0
                  local.get 8
                  i32.store offset=8
                end
                i32.const 0
                local.get 3
                i32.store offset=75376
                i32.const 0
                local.get 4
                i32.store offset=75364
              end
              local.get 7
              i32.const 8
              i32.add
              local.set 0
              br 4 (;@1;)
            end
            i32.const -1
            local.set 3
            local.get 0
            i32.const -65
            i32.gt_u
            br_if 0 (;@4;)
            local.get 0
            i32.const 11
            i32.add
            local.tee 4
            i32.const -8
            i32.and
            local.set 3
            i32.const 0
            i32.load offset=75360
            local.tee 11
            i32.eqz
            br_if 0 (;@4;)
            i32.const 31
            local.set 6
            block  ;; label = @5
              local.get 0
              i32.const 16777204
              i32.gt_u
              br_if 0 (;@5;)
              local.get 3
              i32.const 38
              local.get 4
              i32.const 8
              i32.shr_u
              i32.clz
              local.tee 0
              i32.sub
              i32.shr_u
              i32.const 1
              i32.and
              local.get 0
              i32.const 1
              i32.shl
              i32.sub
              i32.const 62
              i32.add
              local.set 6
            end
            i32.const 0
            local.get 3
            i32.sub
            local.set 4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 6
                    i32.const 2
                    i32.shl
                    i32.const 75660
                    i32.add
                    i32.load
                    local.tee 5
                    br_if 0 (;@8;)
                    i32.const 0
                    local.set 0
                    i32.const 0
                    local.set 8
                    br 1 (;@7;)
                  end
                  i32.const 0
                  local.set 0
                  local.get 3
                  i32.const 0
                  i32.const 25
                  local.get 6
                  i32.const 1
                  i32.shr_u
                  i32.sub
                  local.get 6
                  i32.const 31
                  i32.eq
                  select
                  i32.shl
                  local.set 7
                  i32.const 0
                  local.set 8
                  loop  ;; label = @8
                    block  ;; label = @9
                      local.get 5
                      i32.load offset=4
                      i32.const -8
                      i32.and
                      local.get 3
                      i32.sub
                      local.tee 2
                      local.get 4
                      i32.ge_u
                      br_if 0 (;@9;)
                      local.get 2
                      local.set 4
                      local.get 5
                      local.set 8
                      local.get 2
                      br_if 0 (;@9;)
                      i32.const 0
                      local.set 4
                      local.get 5
                      local.set 8
                      local.get 5
                      local.set 0
                      br 3 (;@6;)
                    end
                    local.get 0
                    local.get 5
                    i32.load offset=20
                    local.tee 2
                    local.get 2
                    local.get 5
                    local.get 7
                    i32.const 29
                    i32.shr_u
                    i32.const 4
                    i32.and
                    i32.add
                    i32.load offset=16
                    local.tee 12
                    i32.eq
                    select
                    local.get 0
                    local.get 2
                    select
                    local.set 0
                    local.get 7
                    i32.const 1
                    i32.shl
                    local.set 7
                    local.get 12
                    local.set 5
                    local.get 12
                    br_if 0 (;@8;)
                  end
                end
                block  ;; label = @7
                  local.get 0
                  local.get 8
                  i32.or
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 8
                  i32.const 2
                  local.get 6
                  i32.shl
                  local.tee 0
                  i32.const 0
                  local.get 0
                  i32.sub
                  i32.or
                  local.get 11
                  i32.and
                  local.tee 0
                  i32.eqz
                  br_if 3 (;@4;)
                  local.get 0
                  i32.ctz
                  i32.const 2
                  i32.shl
                  i32.const 75660
                  i32.add
                  i32.load
                  local.set 0
                end
                local.get 0
                i32.eqz
                br_if 1 (;@5;)
              end
              loop  ;; label = @6
                local.get 0
                i32.load offset=4
                i32.const -8
                i32.and
                local.get 3
                i32.sub
                local.tee 2
                local.get 4
                i32.lt_u
                local.set 7
                block  ;; label = @7
                  local.get 0
                  i32.load offset=16
                  local.tee 5
                  br_if 0 (;@7;)
                  local.get 0
                  i32.load offset=20
                  local.set 5
                end
                local.get 2
                local.get 4
                local.get 7
                select
                local.set 4
                local.get 0
                local.get 8
                local.get 7
                select
                local.set 8
                local.get 5
                local.set 0
                local.get 5
                br_if 0 (;@6;)
              end
            end
            local.get 8
            i32.eqz
            br_if 0 (;@4;)
            local.get 4
            i32.const 0
            i32.load offset=75364
            local.get 3
            i32.sub
            i32.ge_u
            br_if 0 (;@4;)
            local.get 8
            i32.const 0
            i32.load offset=75372
            local.tee 12
            i32.lt_u
            br_if 1 (;@3;)
            local.get 8
            i32.load offset=24
            local.set 6
            block  ;; label = @5
              block  ;; label = @6
                local.get 8
                i32.load offset=12
                local.tee 0
                local.get 8
                i32.eq
                br_if 0 (;@6;)
                local.get 8
                i32.load offset=8
                local.tee 5
                local.get 12
                i32.lt_u
                br_if 3 (;@3;)
                local.get 5
                i32.load offset=12
                local.get 8
                i32.ne
                br_if 3 (;@3;)
                local.get 0
                i32.load offset=8
                local.get 8
                i32.ne
                br_if 3 (;@3;)
                local.get 5
                local.get 0
                i32.store offset=12
                local.get 0
                local.get 5
                i32.store offset=8
                br 1 (;@5;)
              end
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 8
                    i32.load offset=20
                    local.tee 5
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 8
                    i32.const 20
                    i32.add
                    local.set 7
                    br 1 (;@7;)
                  end
                  local.get 8
                  i32.load offset=16
                  local.tee 5
                  i32.eqz
                  br_if 1 (;@6;)
                  local.get 8
                  i32.const 16
                  i32.add
                  local.set 7
                end
                loop  ;; label = @7
                  local.get 7
                  local.set 2
                  local.get 5
                  local.tee 0
                  i32.const 20
                  i32.add
                  local.set 7
                  local.get 0
                  i32.load offset=20
                  local.tee 5
                  br_if 0 (;@7;)
                  local.get 0
                  i32.const 16
                  i32.add
                  local.set 7
                  local.get 0
                  i32.load offset=16
                  local.tee 5
                  br_if 0 (;@7;)
                end
                local.get 2
                local.get 12
                i32.lt_u
                br_if 3 (;@3;)
                local.get 2
                i32.const 0
                i32.store
                br 1 (;@5;)
              end
              i32.const 0
              local.set 0
            end
            block  ;; label = @5
              local.get 6
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                block  ;; label = @7
                  local.get 8
                  local.get 8
                  i32.load offset=28
                  local.tee 7
                  i32.const 2
                  i32.shl
                  i32.const 75660
                  i32.add
                  local.tee 5
                  i32.load
                  i32.ne
                  br_if 0 (;@7;)
                  local.get 5
                  local.get 0
                  i32.store
                  local.get 0
                  br_if 1 (;@6;)
                  i32.const 0
                  local.get 11
                  i32.const -2
                  local.get 7
                  i32.rotl
                  i32.and
                  local.tee 11
                  i32.store offset=75360
                  br 2 (;@5;)
                end
                local.get 6
                local.get 12
                i32.lt_u
                br_if 3 (;@3;)
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 6
                    i32.load offset=16
                    local.get 8
                    i32.ne
                    br_if 0 (;@8;)
                    local.get 6
                    local.get 0
                    i32.store offset=16
                    br 1 (;@7;)
                  end
                  local.get 6
                  local.get 0
                  i32.store offset=20
                end
                local.get 0
                i32.eqz
                br_if 1 (;@5;)
              end
              local.get 0
              local.get 12
              i32.lt_u
              br_if 2 (;@3;)
              local.get 0
              local.get 6
              i32.store offset=24
              block  ;; label = @6
                local.get 8
                i32.load offset=16
                local.tee 5
                i32.eqz
                br_if 0 (;@6;)
                local.get 5
                local.get 12
                i32.lt_u
                br_if 3 (;@3;)
                local.get 0
                local.get 5
                i32.store offset=16
                local.get 5
                local.get 0
                i32.store offset=24
              end
              local.get 8
              i32.load offset=20
              local.tee 5
              i32.eqz
              br_if 0 (;@5;)
              local.get 5
              local.get 12
              i32.lt_u
              br_if 2 (;@3;)
              local.get 0
              local.get 5
              i32.store offset=20
              local.get 5
              local.get 0
              i32.store offset=24
            end
            block  ;; label = @5
              block  ;; label = @6
                local.get 4
                i32.const 15
                i32.gt_u
                br_if 0 (;@6;)
                local.get 8
                local.get 4
                local.get 3
                i32.add
                local.tee 0
                i32.const 3
                i32.or
                i32.store offset=4
                local.get 8
                local.get 0
                i32.add
                local.tee 0
                local.get 0
                i32.load offset=4
                i32.const 1
                i32.or
                i32.store offset=4
                br 1 (;@5;)
              end
              local.get 8
              local.get 3
              i32.const 3
              i32.or
              i32.store offset=4
              local.get 8
              local.get 3
              i32.add
              local.tee 7
              local.get 4
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 7
              local.get 4
              i32.add
              local.get 4
              i32.store
              block  ;; label = @6
                local.get 4
                i32.const 255
                i32.gt_u
                br_if 0 (;@6;)
                local.get 4
                i32.const -8
                i32.and
                i32.const 75396
                i32.add
                local.set 0
                block  ;; label = @7
                  block  ;; label = @8
                    i32.const 0
                    i32.load offset=75356
                    local.tee 3
                    i32.const 1
                    local.get 4
                    i32.const 3
                    i32.shr_u
                    i32.shl
                    local.tee 4
                    i32.and
                    br_if 0 (;@8;)
                    i32.const 0
                    local.get 3
                    local.get 4
                    i32.or
                    i32.store offset=75356
                    local.get 0
                    local.set 4
                    br 1 (;@7;)
                  end
                  local.get 0
                  i32.load offset=8
                  local.tee 4
                  local.get 12
                  i32.lt_u
                  br_if 4 (;@3;)
                end
                local.get 0
                local.get 7
                i32.store offset=8
                local.get 4
                local.get 7
                i32.store offset=12
                local.get 7
                local.get 0
                i32.store offset=12
                local.get 7
                local.get 4
                i32.store offset=8
                br 1 (;@5;)
              end
              i32.const 31
              local.set 0
              block  ;; label = @6
                local.get 4
                i32.const 16777215
                i32.gt_u
                br_if 0 (;@6;)
                local.get 4
                i32.const 38
                local.get 4
                i32.const 8
                i32.shr_u
                i32.clz
                local.tee 0
                i32.sub
                i32.shr_u
                i32.const 1
                i32.and
                local.get 0
                i32.const 1
                i32.shl
                i32.sub
                i32.const 62
                i32.add
                local.set 0
              end
              local.get 7
              local.get 0
              i32.store offset=28
              local.get 7
              i64.const 0
              i64.store offset=16 align=4
              local.get 0
              i32.const 2
              i32.shl
              i32.const 75660
              i32.add
              local.set 3
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 11
                    i32.const 1
                    local.get 0
                    i32.shl
                    local.tee 5
                    i32.and
                    br_if 0 (;@8;)
                    i32.const 0
                    local.get 11
                    local.get 5
                    i32.or
                    i32.store offset=75360
                    local.get 3
                    local.get 7
                    i32.store
                    local.get 7
                    local.get 3
                    i32.store offset=24
                    br 1 (;@7;)
                  end
                  local.get 4
                  i32.const 0
                  i32.const 25
                  local.get 0
                  i32.const 1
                  i32.shr_u
                  i32.sub
                  local.get 0
                  i32.const 31
                  i32.eq
                  select
                  i32.shl
                  local.set 0
                  local.get 3
                  i32.load
                  local.set 5
                  loop  ;; label = @8
                    local.get 5
                    local.tee 3
                    i32.load offset=4
                    i32.const -8
                    i32.and
                    local.get 4
                    i32.eq
                    br_if 2 (;@6;)
                    local.get 0
                    i32.const 29
                    i32.shr_u
                    local.set 5
                    local.get 0
                    i32.const 1
                    i32.shl
                    local.set 0
                    local.get 3
                    local.get 5
                    i32.const 4
                    i32.and
                    i32.add
                    local.tee 2
                    i32.load offset=16
                    local.tee 5
                    br_if 0 (;@8;)
                  end
                  local.get 2
                  i32.const 16
                  i32.add
                  local.tee 0
                  local.get 12
                  i32.lt_u
                  br_if 4 (;@3;)
                  local.get 0
                  local.get 7
                  i32.store
                  local.get 7
                  local.get 3
                  i32.store offset=24
                end
                local.get 7
                local.get 7
                i32.store offset=12
                local.get 7
                local.get 7
                i32.store offset=8
                br 1 (;@5;)
              end
              local.get 3
              local.get 12
              i32.lt_u
              br_if 2 (;@3;)
              local.get 3
              i32.load offset=8
              local.tee 0
              local.get 12
              i32.lt_u
              br_if 2 (;@3;)
              local.get 0
              local.get 7
              i32.store offset=12
              local.get 3
              local.get 7
              i32.store offset=8
              local.get 7
              i32.const 0
              i32.store offset=24
              local.get 7
              local.get 3
              i32.store offset=12
              local.get 7
              local.get 0
              i32.store offset=8
            end
            local.get 8
            i32.const 8
            i32.add
            local.set 0
            br 3 (;@1;)
          end
          block  ;; label = @4
            i32.const 0
            i32.load offset=75364
            local.tee 0
            local.get 3
            i32.lt_u
            br_if 0 (;@4;)
            i32.const 0
            i32.load offset=75376
            local.set 4
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                local.get 3
                i32.sub
                local.tee 5
                i32.const 16
                i32.lt_u
                br_if 0 (;@6;)
                local.get 4
                local.get 3
                i32.add
                local.tee 7
                local.get 5
                i32.const 1
                i32.or
                i32.store offset=4
                local.get 4
                local.get 0
                i32.add
                local.get 5
                i32.store
                local.get 4
                local.get 3
                i32.const 3
                i32.or
                i32.store offset=4
                br 1 (;@5;)
              end
              local.get 4
              local.get 0
              i32.const 3
              i32.or
              i32.store offset=4
              local.get 4
              local.get 0
              i32.add
              local.tee 0
              local.get 0
              i32.load offset=4
              i32.const 1
              i32.or
              i32.store offset=4
              i32.const 0
              local.set 7
              i32.const 0
              local.set 5
            end
            i32.const 0
            local.get 5
            i32.store offset=75364
            i32.const 0
            local.get 7
            i32.store offset=75376
            local.get 4
            i32.const 8
            i32.add
            local.set 0
            br 3 (;@1;)
          end
          block  ;; label = @4
            i32.const 0
            i32.load offset=75368
            local.tee 7
            local.get 3
            i32.le_u
            br_if 0 (;@4;)
            i32.const 0
            local.get 7
            local.get 3
            i32.sub
            local.tee 4
            i32.store offset=75368
            i32.const 0
            i32.const 0
            i32.load offset=75380
            local.tee 0
            local.get 3
            i32.add
            local.tee 5
            i32.store offset=75380
            local.get 5
            local.get 4
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 0
            local.get 3
            i32.const 3
            i32.or
            i32.store offset=4
            local.get 0
            i32.const 8
            i32.add
            local.set 0
            br 3 (;@1;)
          end
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load offset=75828
              i32.eqz
              br_if 0 (;@5;)
              i32.const 0
              i32.load offset=75836
              local.set 4
              br 1 (;@4;)
            end
            i32.const 0
            i64.const -1
            i64.store offset=75840 align=4
            i32.const 0
            i64.const 17592186048512
            i64.store offset=75832 align=4
            i32.const 0
            local.get 1
            i32.const 12
            i32.add
            i32.const -16
            i32.and
            i32.const 1431655768
            i32.xor
            i32.store offset=75828
            i32.const 0
            i32.const 0
            i32.store offset=75848
            i32.const 0
            i32.const 0
            i32.store offset=75800
            i32.const 4096
            local.set 4
          end
          i32.const 0
          local.set 0
          local.get 4
          local.get 3
          i32.const 47
          i32.add
          local.tee 6
          i32.add
          local.tee 2
          i32.const 0
          local.get 4
          i32.sub
          local.tee 12
          i32.and
          local.tee 8
          local.get 3
          i32.le_u
          br_if 2 (;@1;)
          i32.const 0
          local.set 0
          block  ;; label = @4
            i32.const 0
            i32.load offset=75796
            local.tee 4
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            i32.load offset=75788
            local.tee 5
            local.get 8
            i32.add
            local.tee 11
            local.get 5
            i32.le_u
            br_if 3 (;@1;)
            local.get 11
            local.get 4
            i32.gt_u
            br_if 3 (;@1;)
          end
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                i32.const 0
                i32.load8_u offset=75800
                i32.const 4
                i32.and
                br_if 0 (;@6;)
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          i32.const 0
                          i32.load offset=75380
                          local.tee 4
                          i32.eqz
                          br_if 0 (;@11;)
                          i32.const 75804
                          local.set 0
                          loop  ;; label = @12
                            block  ;; label = @13
                              local.get 4
                              local.get 0
                              i32.load
                              local.tee 5
                              i32.lt_u
                              br_if 0 (;@13;)
                              local.get 4
                              local.get 5
                              local.get 0
                              i32.load offset=4
                              i32.add
                              i32.lt_u
                              br_if 3 (;@10;)
                            end
                            local.get 0
                            i32.load offset=8
                            local.tee 0
                            br_if 0 (;@12;)
                          end
                        end
                        i32.const 0
                        call $sbrk
                        local.tee 7
                        i32.const -1
                        i32.eq
                        br_if 3 (;@7;)
                        local.get 8
                        local.set 2
                        block  ;; label = @11
                          i32.const 0
                          i32.load offset=75832
                          local.tee 0
                          i32.const -1
                          i32.add
                          local.tee 4
                          local.get 7
                          i32.and
                          i32.eqz
                          br_if 0 (;@11;)
                          local.get 8
                          local.get 7
                          i32.sub
                          local.get 4
                          local.get 7
                          i32.add
                          i32.const 0
                          local.get 0
                          i32.sub
                          i32.and
                          i32.add
                          local.set 2
                        end
                        local.get 2
                        local.get 3
                        i32.le_u
                        br_if 3 (;@7;)
                        block  ;; label = @11
                          i32.const 0
                          i32.load offset=75796
                          local.tee 0
                          i32.eqz
                          br_if 0 (;@11;)
                          i32.const 0
                          i32.load offset=75788
                          local.tee 4
                          local.get 2
                          i32.add
                          local.tee 5
                          local.get 4
                          i32.le_u
                          br_if 4 (;@7;)
                          local.get 5
                          local.get 0
                          i32.gt_u
                          br_if 4 (;@7;)
                        end
                        local.get 2
                        call $sbrk
                        local.tee 0
                        local.get 7
                        i32.ne
                        br_if 1 (;@9;)
                        br 5 (;@5;)
                      end
                      local.get 2
                      local.get 7
                      i32.sub
                      local.get 12
                      i32.and
                      local.tee 2
                      call $sbrk
                      local.tee 7
                      local.get 0
                      i32.load
                      local.get 0
                      i32.load offset=4
                      i32.add
                      i32.eq
                      br_if 1 (;@8;)
                      local.get 7
                      local.set 0
                    end
                    local.get 0
                    i32.const -1
                    i32.eq
                    br_if 1 (;@7;)
                    block  ;; label = @9
                      local.get 2
                      local.get 3
                      i32.const 48
                      i32.add
                      i32.lt_u
                      br_if 0 (;@9;)
                      local.get 0
                      local.set 7
                      br 4 (;@5;)
                    end
                    local.get 6
                    local.get 2
                    i32.sub
                    i32.const 0
                    i32.load offset=75836
                    local.tee 4
                    i32.add
                    i32.const 0
                    local.get 4
                    i32.sub
                    i32.and
                    local.tee 4
                    call $sbrk
                    i32.const -1
                    i32.eq
                    br_if 1 (;@7;)
                    local.get 4
                    local.get 2
                    i32.add
                    local.set 2
                    local.get 0
                    local.set 7
                    br 3 (;@5;)
                  end
                  local.get 7
                  i32.const -1
                  i32.ne
                  br_if 2 (;@5;)
                end
                i32.const 0
                i32.const 0
                i32.load offset=75800
                i32.const 4
                i32.or
                i32.store offset=75800
              end
              local.get 8
              call $sbrk
              local.set 7
              i32.const 0
              call $sbrk
              local.set 0
              local.get 7
              i32.const -1
              i32.eq
              br_if 1 (;@4;)
              local.get 0
              i32.const -1
              i32.eq
              br_if 1 (;@4;)
              local.get 7
              local.get 0
              i32.ge_u
              br_if 1 (;@4;)
              local.get 0
              local.get 7
              i32.sub
              local.tee 2
              local.get 3
              i32.const 40
              i32.add
              i32.le_u
              br_if 1 (;@4;)
            end
            i32.const 0
            i32.const 0
            i32.load offset=75788
            local.get 2
            i32.add
            local.tee 0
            i32.store offset=75788
            block  ;; label = @5
              local.get 0
              i32.const 0
              i32.load offset=75792
              i32.le_u
              br_if 0 (;@5;)
              i32.const 0
              local.get 0
              i32.store offset=75792
            end
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    i32.const 0
                    i32.load offset=75380
                    local.tee 4
                    i32.eqz
                    br_if 0 (;@8;)
                    i32.const 75804
                    local.set 0
                    loop  ;; label = @9
                      local.get 7
                      local.get 0
                      i32.load
                      local.tee 5
                      local.get 0
                      i32.load offset=4
                      local.tee 8
                      i32.add
                      i32.eq
                      br_if 2 (;@7;)
                      local.get 0
                      i32.load offset=8
                      local.tee 0
                      br_if 0 (;@9;)
                      br 3 (;@6;)
                    end
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      i32.const 0
                      i32.load offset=75372
                      local.tee 0
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 7
                      local.get 0
                      i32.ge_u
                      br_if 1 (;@8;)
                    end
                    i32.const 0
                    local.get 7
                    i32.store offset=75372
                  end
                  i32.const 0
                  local.set 0
                  i32.const 0
                  local.get 2
                  i32.store offset=75808
                  i32.const 0
                  local.get 7
                  i32.store offset=75804
                  i32.const 0
                  i32.const -1
                  i32.store offset=75388
                  i32.const 0
                  i32.const 0
                  i32.load offset=75828
                  i32.store offset=75392
                  i32.const 0
                  i32.const 0
                  i32.store offset=75816
                  loop  ;; label = @8
                    local.get 0
                    i32.const 3
                    i32.shl
                    local.tee 4
                    i32.const 75404
                    i32.add
                    local.get 4
                    i32.const 75396
                    i32.add
                    local.tee 5
                    i32.store
                    local.get 4
                    i32.const 75408
                    i32.add
                    local.get 5
                    i32.store
                    local.get 0
                    i32.const 1
                    i32.add
                    local.tee 0
                    i32.const 32
                    i32.ne
                    br_if 0 (;@8;)
                  end
                  i32.const 0
                  local.get 2
                  i32.const -40
                  i32.add
                  local.tee 0
                  i32.const -8
                  local.get 7
                  i32.sub
                  i32.const 7
                  i32.and
                  local.tee 4
                  i32.sub
                  local.tee 5
                  i32.store offset=75368
                  i32.const 0
                  local.get 7
                  local.get 4
                  i32.add
                  local.tee 4
                  i32.store offset=75380
                  local.get 4
                  local.get 5
                  i32.const 1
                  i32.or
                  i32.store offset=4
                  local.get 7
                  local.get 0
                  i32.add
                  i32.const 40
                  i32.store offset=4
                  i32.const 0
                  i32.const 0
                  i32.load offset=75844
                  i32.store offset=75384
                  br 2 (;@5;)
                end
                local.get 4
                local.get 7
                i32.ge_u
                br_if 0 (;@6;)
                local.get 4
                local.get 5
                i32.lt_u
                br_if 0 (;@6;)
                local.get 0
                i32.load offset=12
                i32.const 8
                i32.and
                br_if 0 (;@6;)
                local.get 0
                local.get 8
                local.get 2
                i32.add
                i32.store offset=4
                i32.const 0
                local.get 4
                i32.const -8
                local.get 4
                i32.sub
                i32.const 7
                i32.and
                local.tee 0
                i32.add
                local.tee 5
                i32.store offset=75380
                i32.const 0
                i32.const 0
                i32.load offset=75368
                local.get 2
                i32.add
                local.tee 7
                local.get 0
                i32.sub
                local.tee 0
                i32.store offset=75368
                local.get 5
                local.get 0
                i32.const 1
                i32.or
                i32.store offset=4
                local.get 4
                local.get 7
                i32.add
                i32.const 40
                i32.store offset=4
                i32.const 0
                i32.const 0
                i32.load offset=75844
                i32.store offset=75384
                br 1 (;@5;)
              end
              block  ;; label = @6
                local.get 7
                i32.const 0
                i32.load offset=75372
                i32.ge_u
                br_if 0 (;@6;)
                i32.const 0
                local.get 7
                i32.store offset=75372
              end
              local.get 7
              local.get 2
              i32.add
              local.set 5
              i32.const 75804
              local.set 0
              block  ;; label = @6
                block  ;; label = @7
                  loop  ;; label = @8
                    local.get 0
                    i32.load
                    local.tee 8
                    local.get 5
                    i32.eq
                    br_if 1 (;@7;)
                    local.get 0
                    i32.load offset=8
                    local.tee 0
                    br_if 0 (;@8;)
                    br 2 (;@6;)
                  end
                end
                local.get 0
                i32.load8_u offset=12
                i32.const 8
                i32.and
                i32.eqz
                br_if 4 (;@2;)
              end
              i32.const 75804
              local.set 0
              block  ;; label = @6
                loop  ;; label = @7
                  block  ;; label = @8
                    local.get 4
                    local.get 0
                    i32.load
                    local.tee 5
                    i32.lt_u
                    br_if 0 (;@8;)
                    local.get 4
                    local.get 5
                    local.get 0
                    i32.load offset=4
                    i32.add
                    local.tee 5
                    i32.lt_u
                    br_if 2 (;@6;)
                  end
                  local.get 0
                  i32.load offset=8
                  local.set 0
                  br 0 (;@7;)
                end
              end
              i32.const 0
              local.get 2
              i32.const -40
              i32.add
              local.tee 0
              i32.const -8
              local.get 7
              i32.sub
              i32.const 7
              i32.and
              local.tee 8
              i32.sub
              local.tee 12
              i32.store offset=75368
              i32.const 0
              local.get 7
              local.get 8
              i32.add
              local.tee 8
              i32.store offset=75380
              local.get 8
              local.get 12
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 7
              local.get 0
              i32.add
              i32.const 40
              i32.store offset=4
              i32.const 0
              i32.const 0
              i32.load offset=75844
              i32.store offset=75384
              local.get 4
              local.get 5
              i32.const 39
              local.get 5
              i32.sub
              i32.const 7
              i32.and
              i32.add
              i32.const -47
              i32.add
              local.tee 0
              local.get 0
              local.get 4
              i32.const 16
              i32.add
              i32.lt_u
              select
              local.tee 8
              i32.const 27
              i32.store offset=4
              local.get 8
              i32.const 16
              i32.add
              i32.const 0
              i64.load offset=75812 align=4
              i64.store align=4
              local.get 8
              i32.const 0
              i64.load offset=75804 align=4
              i64.store offset=8 align=4
              i32.const 0
              local.get 8
              i32.const 8
              i32.add
              i32.store offset=75812
              i32.const 0
              local.get 2
              i32.store offset=75808
              i32.const 0
              local.get 7
              i32.store offset=75804
              i32.const 0
              i32.const 0
              i32.store offset=75816
              local.get 8
              i32.const 24
              i32.add
              local.set 0
              loop  ;; label = @6
                local.get 0
                i32.const 7
                i32.store offset=4
                local.get 0
                i32.const 8
                i32.add
                local.set 7
                local.get 0
                i32.const 4
                i32.add
                local.set 0
                local.get 7
                local.get 5
                i32.lt_u
                br_if 0 (;@6;)
              end
              local.get 8
              local.get 4
              i32.eq
              br_if 0 (;@5;)
              local.get 8
              local.get 8
              i32.load offset=4
              i32.const -2
              i32.and
              i32.store offset=4
              local.get 4
              local.get 8
              local.get 4
              i32.sub
              local.tee 7
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 8
              local.get 7
              i32.store
              block  ;; label = @6
                block  ;; label = @7
                  local.get 7
                  i32.const 255
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 7
                  i32.const -8
                  i32.and
                  i32.const 75396
                  i32.add
                  local.set 0
                  block  ;; label = @8
                    block  ;; label = @9
                      i32.const 0
                      i32.load offset=75356
                      local.tee 5
                      i32.const 1
                      local.get 7
                      i32.const 3
                      i32.shr_u
                      i32.shl
                      local.tee 7
                      i32.and
                      br_if 0 (;@9;)
                      i32.const 0
                      local.get 5
                      local.get 7
                      i32.or
                      i32.store offset=75356
                      local.get 0
                      local.set 5
                      br 1 (;@8;)
                    end
                    local.get 0
                    i32.load offset=8
                    local.tee 5
                    i32.const 0
                    i32.load offset=75372
                    i32.lt_u
                    br_if 5 (;@3;)
                  end
                  local.get 0
                  local.get 4
                  i32.store offset=8
                  local.get 5
                  local.get 4
                  i32.store offset=12
                  i32.const 12
                  local.set 7
                  i32.const 8
                  local.set 8
                  br 1 (;@6;)
                end
                i32.const 31
                local.set 0
                block  ;; label = @7
                  local.get 7
                  i32.const 16777215
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 7
                  i32.const 38
                  local.get 7
                  i32.const 8
                  i32.shr_u
                  i32.clz
                  local.tee 0
                  i32.sub
                  i32.shr_u
                  i32.const 1
                  i32.and
                  local.get 0
                  i32.const 1
                  i32.shl
                  i32.sub
                  i32.const 62
                  i32.add
                  local.set 0
                end
                local.get 4
                local.get 0
                i32.store offset=28
                local.get 4
                i64.const 0
                i64.store offset=16 align=4
                local.get 0
                i32.const 2
                i32.shl
                i32.const 75660
                i32.add
                local.set 5
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      i32.const 0
                      i32.load offset=75360
                      local.tee 8
                      i32.const 1
                      local.get 0
                      i32.shl
                      local.tee 2
                      i32.and
                      br_if 0 (;@9;)
                      i32.const 0
                      local.get 8
                      local.get 2
                      i32.or
                      i32.store offset=75360
                      local.get 5
                      local.get 4
                      i32.store
                      local.get 4
                      local.get 5
                      i32.store offset=24
                      br 1 (;@8;)
                    end
                    local.get 7
                    i32.const 0
                    i32.const 25
                    local.get 0
                    i32.const 1
                    i32.shr_u
                    i32.sub
                    local.get 0
                    i32.const 31
                    i32.eq
                    select
                    i32.shl
                    local.set 0
                    local.get 5
                    i32.load
                    local.set 8
                    loop  ;; label = @9
                      local.get 8
                      local.tee 5
                      i32.load offset=4
                      i32.const -8
                      i32.and
                      local.get 7
                      i32.eq
                      br_if 2 (;@7;)
                      local.get 0
                      i32.const 29
                      i32.shr_u
                      local.set 8
                      local.get 0
                      i32.const 1
                      i32.shl
                      local.set 0
                      local.get 5
                      local.get 8
                      i32.const 4
                      i32.and
                      i32.add
                      local.tee 2
                      i32.load offset=16
                      local.tee 8
                      br_if 0 (;@9;)
                    end
                    local.get 2
                    i32.const 16
                    i32.add
                    local.tee 0
                    i32.const 0
                    i32.load offset=75372
                    i32.lt_u
                    br_if 5 (;@3;)
                    local.get 0
                    local.get 4
                    i32.store
                    local.get 4
                    local.get 5
                    i32.store offset=24
                  end
                  i32.const 8
                  local.set 7
                  i32.const 12
                  local.set 8
                  local.get 4
                  local.set 5
                  local.get 4
                  local.set 0
                  br 1 (;@6;)
                end
                local.get 5
                i32.const 0
                i32.load offset=75372
                local.tee 7
                i32.lt_u
                br_if 3 (;@3;)
                local.get 5
                i32.load offset=8
                local.tee 0
                local.get 7
                i32.lt_u
                br_if 3 (;@3;)
                local.get 0
                local.get 4
                i32.store offset=12
                local.get 5
                local.get 4
                i32.store offset=8
                local.get 4
                local.get 0
                i32.store offset=8
                i32.const 0
                local.set 0
                i32.const 24
                local.set 7
                i32.const 12
                local.set 8
              end
              local.get 4
              local.get 8
              i32.add
              local.get 5
              i32.store
              local.get 4
              local.get 7
              i32.add
              local.get 0
              i32.store
            end
            i32.const 0
            i32.load offset=75368
            local.tee 0
            local.get 3
            i32.le_u
            br_if 0 (;@4;)
            i32.const 0
            local.get 0
            local.get 3
            i32.sub
            local.tee 4
            i32.store offset=75368
            i32.const 0
            i32.const 0
            i32.load offset=75380
            local.tee 0
            local.get 3
            i32.add
            local.tee 5
            i32.store offset=75380
            local.get 5
            local.get 4
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 0
            local.get 3
            i32.const 3
            i32.or
            i32.store offset=4
            local.get 0
            i32.const 8
            i32.add
            local.set 0
            br 3 (;@1;)
          end
          call $__errno_location
          i32.const 48
          i32.store
          i32.const 0
          local.set 0
          br 2 (;@1;)
        end
        call $abort
        unreachable
      end
      local.get 0
      local.get 7
      i32.store
      local.get 0
      local.get 0
      i32.load offset=4
      local.get 2
      i32.add
      i32.store offset=4
      local.get 7
      local.get 8
      local.get 3
      call $prepend_alloc
      local.set 0
    end
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer
    local.get 0)
  (func $prepend_alloc (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    local.get 0
    i32.const -8
    local.get 0
    i32.sub
    i32.const 7
    i32.and
    i32.add
    local.tee 3
    local.get 2
    i32.const 3
    i32.or
    i32.store offset=4
    local.get 1
    i32.const -8
    local.get 1
    i32.sub
    i32.const 7
    i32.and
    i32.add
    local.tee 4
    local.get 3
    local.get 2
    i32.add
    local.tee 5
    i32.sub
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          i32.const 0
          i32.load offset=75380
          i32.ne
          br_if 0 (;@3;)
          i32.const 0
          local.get 5
          i32.store offset=75380
          i32.const 0
          i32.const 0
          i32.load offset=75368
          local.get 0
          i32.add
          local.tee 2
          i32.store offset=75368
          local.get 5
          local.get 2
          i32.const 1
          i32.or
          i32.store offset=4
          br 1 (;@2;)
        end
        block  ;; label = @3
          local.get 4
          i32.const 0
          i32.load offset=75376
          i32.ne
          br_if 0 (;@3;)
          i32.const 0
          local.get 5
          i32.store offset=75376
          i32.const 0
          i32.const 0
          i32.load offset=75364
          local.get 0
          i32.add
          local.tee 2
          i32.store offset=75364
          local.get 5
          local.get 2
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 5
          local.get 2
          i32.add
          local.get 2
          i32.store
          br 1 (;@2;)
        end
        block  ;; label = @3
          local.get 4
          i32.load offset=4
          local.tee 6
          i32.const 3
          i32.and
          i32.const 1
          i32.ne
          br_if 0 (;@3;)
          local.get 4
          i32.load offset=12
          local.set 2
          block  ;; label = @4
            block  ;; label = @5
              local.get 6
              i32.const 255
              i32.gt_u
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 4
                i32.load offset=8
                local.tee 1
                local.get 6
                i32.const 3
                i32.shr_u
                local.tee 7
                i32.const 3
                i32.shl
                i32.const 75396
                i32.add
                local.tee 8
                i32.eq
                br_if 0 (;@6;)
                local.get 1
                i32.const 0
                i32.load offset=75372
                i32.lt_u
                br_if 5 (;@1;)
                local.get 1
                i32.load offset=12
                local.get 4
                i32.ne
                br_if 5 (;@1;)
              end
              block  ;; label = @6
                local.get 2
                local.get 1
                i32.ne
                br_if 0 (;@6;)
                i32.const 0
                i32.const 0
                i32.load offset=75356
                i32.const -2
                local.get 7
                i32.rotl
                i32.and
                i32.store offset=75356
                br 2 (;@4;)
              end
              block  ;; label = @6
                local.get 2
                local.get 8
                i32.eq
                br_if 0 (;@6;)
                local.get 2
                i32.const 0
                i32.load offset=75372
                i32.lt_u
                br_if 5 (;@1;)
                local.get 2
                i32.load offset=8
                local.get 4
                i32.ne
                br_if 5 (;@1;)
              end
              local.get 1
              local.get 2
              i32.store offset=12
              local.get 2
              local.get 1
              i32.store offset=8
              br 1 (;@4;)
            end
            local.get 4
            i32.load offset=24
            local.set 9
            block  ;; label = @5
              block  ;; label = @6
                local.get 2
                local.get 4
                i32.eq
                br_if 0 (;@6;)
                local.get 4
                i32.load offset=8
                local.tee 1
                i32.const 0
                i32.load offset=75372
                i32.lt_u
                br_if 5 (;@1;)
                local.get 1
                i32.load offset=12
                local.get 4
                i32.ne
                br_if 5 (;@1;)
                local.get 2
                i32.load offset=8
                local.get 4
                i32.ne
                br_if 5 (;@1;)
                local.get 1
                local.get 2
                i32.store offset=12
                local.get 2
                local.get 1
                i32.store offset=8
                br 1 (;@5;)
              end
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 4
                    i32.load offset=20
                    local.tee 1
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 4
                    i32.const 20
                    i32.add
                    local.set 8
                    br 1 (;@7;)
                  end
                  local.get 4
                  i32.load offset=16
                  local.tee 1
                  i32.eqz
                  br_if 1 (;@6;)
                  local.get 4
                  i32.const 16
                  i32.add
                  local.set 8
                end
                loop  ;; label = @7
                  local.get 8
                  local.set 7
                  local.get 1
                  local.tee 2
                  i32.const 20
                  i32.add
                  local.set 8
                  local.get 2
                  i32.load offset=20
                  local.tee 1
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const 16
                  i32.add
                  local.set 8
                  local.get 2
                  i32.load offset=16
                  local.tee 1
                  br_if 0 (;@7;)
                end
                local.get 7
                i32.const 0
                i32.load offset=75372
                i32.lt_u
                br_if 5 (;@1;)
                local.get 7
                i32.const 0
                i32.store
                br 1 (;@5;)
              end
              i32.const 0
              local.set 2
            end
            local.get 9
            i32.eqz
            br_if 0 (;@4;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 4
                local.get 4
                i32.load offset=28
                local.tee 8
                i32.const 2
                i32.shl
                i32.const 75660
                i32.add
                local.tee 1
                i32.load
                i32.ne
                br_if 0 (;@6;)
                local.get 1
                local.get 2
                i32.store
                local.get 2
                br_if 1 (;@5;)
                i32.const 0
                i32.const 0
                i32.load offset=75360
                i32.const -2
                local.get 8
                i32.rotl
                i32.and
                i32.store offset=75360
                br 2 (;@4;)
              end
              local.get 9
              i32.const 0
              i32.load offset=75372
              i32.lt_u
              br_if 4 (;@1;)
              block  ;; label = @6
                block  ;; label = @7
                  local.get 9
                  i32.load offset=16
                  local.get 4
                  i32.ne
                  br_if 0 (;@7;)
                  local.get 9
                  local.get 2
                  i32.store offset=16
                  br 1 (;@6;)
                end
                local.get 9
                local.get 2
                i32.store offset=20
              end
              local.get 2
              i32.eqz
              br_if 1 (;@4;)
            end
            local.get 2
            i32.const 0
            i32.load offset=75372
            local.tee 8
            i32.lt_u
            br_if 3 (;@1;)
            local.get 2
            local.get 9
            i32.store offset=24
            block  ;; label = @5
              local.get 4
              i32.load offset=16
              local.tee 1
              i32.eqz
              br_if 0 (;@5;)
              local.get 1
              local.get 8
              i32.lt_u
              br_if 4 (;@1;)
              local.get 2
              local.get 1
              i32.store offset=16
              local.get 1
              local.get 2
              i32.store offset=24
            end
            local.get 4
            i32.load offset=20
            local.tee 1
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            local.get 8
            i32.lt_u
            br_if 3 (;@1;)
            local.get 2
            local.get 1
            i32.store offset=20
            local.get 1
            local.get 2
            i32.store offset=24
          end
          local.get 6
          i32.const -8
          i32.and
          local.tee 2
          local.get 0
          i32.add
          local.set 0
          local.get 4
          local.get 2
          i32.add
          local.tee 4
          i32.load offset=4
          local.set 6
        end
        local.get 4
        local.get 6
        i32.const -2
        i32.and
        i32.store offset=4
        local.get 5
        local.get 0
        i32.const 1
        i32.or
        i32.store offset=4
        local.get 5
        local.get 0
        i32.add
        local.get 0
        i32.store
        block  ;; label = @3
          local.get 0
          i32.const 255
          i32.gt_u
          br_if 0 (;@3;)
          local.get 0
          i32.const -8
          i32.and
          i32.const 75396
          i32.add
          local.set 2
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load offset=75356
              local.tee 1
              i32.const 1
              local.get 0
              i32.const 3
              i32.shr_u
              i32.shl
              local.tee 0
              i32.and
              br_if 0 (;@5;)
              i32.const 0
              local.get 1
              local.get 0
              i32.or
              i32.store offset=75356
              local.get 2
              local.set 0
              br 1 (;@4;)
            end
            local.get 2
            i32.load offset=8
            local.tee 0
            i32.const 0
            i32.load offset=75372
            i32.lt_u
            br_if 3 (;@1;)
          end
          local.get 2
          local.get 5
          i32.store offset=8
          local.get 0
          local.get 5
          i32.store offset=12
          local.get 5
          local.get 2
          i32.store offset=12
          local.get 5
          local.get 0
          i32.store offset=8
          br 1 (;@2;)
        end
        i32.const 31
        local.set 2
        block  ;; label = @3
          local.get 0
          i32.const 16777215
          i32.gt_u
          br_if 0 (;@3;)
          local.get 0
          i32.const 38
          local.get 0
          i32.const 8
          i32.shr_u
          i32.clz
          local.tee 2
          i32.sub
          i32.shr_u
          i32.const 1
          i32.and
          local.get 2
          i32.const 1
          i32.shl
          i32.sub
          i32.const 62
          i32.add
          local.set 2
        end
        local.get 5
        local.get 2
        i32.store offset=28
        local.get 5
        i64.const 0
        i64.store offset=16 align=4
        local.get 2
        i32.const 2
        i32.shl
        i32.const 75660
        i32.add
        local.set 1
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load offset=75360
              local.tee 8
              i32.const 1
              local.get 2
              i32.shl
              local.tee 4
              i32.and
              br_if 0 (;@5;)
              i32.const 0
              local.get 8
              local.get 4
              i32.or
              i32.store offset=75360
              local.get 1
              local.get 5
              i32.store
              local.get 5
              local.get 1
              i32.store offset=24
              br 1 (;@4;)
            end
            local.get 0
            i32.const 0
            i32.const 25
            local.get 2
            i32.const 1
            i32.shr_u
            i32.sub
            local.get 2
            i32.const 31
            i32.eq
            select
            i32.shl
            local.set 2
            local.get 1
            i32.load
            local.set 8
            loop  ;; label = @5
              local.get 8
              local.tee 1
              i32.load offset=4
              i32.const -8
              i32.and
              local.get 0
              i32.eq
              br_if 2 (;@3;)
              local.get 2
              i32.const 29
              i32.shr_u
              local.set 8
              local.get 2
              i32.const 1
              i32.shl
              local.set 2
              local.get 1
              local.get 8
              i32.const 4
              i32.and
              i32.add
              local.tee 4
              i32.load offset=16
              local.tee 8
              br_if 0 (;@5;)
            end
            local.get 4
            i32.const 16
            i32.add
            local.tee 2
            i32.const 0
            i32.load offset=75372
            i32.lt_u
            br_if 3 (;@1;)
            local.get 2
            local.get 5
            i32.store
            local.get 5
            local.get 1
            i32.store offset=24
          end
          local.get 5
          local.get 5
          i32.store offset=12
          local.get 5
          local.get 5
          i32.store offset=8
          br 1 (;@2;)
        end
        local.get 1
        i32.const 0
        i32.load offset=75372
        local.tee 0
        i32.lt_u
        br_if 1 (;@1;)
        local.get 1
        i32.load offset=8
        local.tee 2
        local.get 0
        i32.lt_u
        br_if 1 (;@1;)
        local.get 2
        local.get 5
        i32.store offset=12
        local.get 1
        local.get 5
        i32.store offset=8
        local.get 5
        i32.const 0
        i32.store offset=24
        local.get 5
        local.get 1
        i32.store offset=12
        local.get 5
        local.get 2
        i32.store offset=8
      end
      local.get 3
      i32.const 8
      i32.add
      return
    end
    call $abort
    unreachable)
  (func $emscripten_builtin_free (type 1) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const -8
        i32.add
        local.tee 1
        i32.const 0
        i32.load offset=75372
        local.tee 2
        i32.lt_u
        br_if 1 (;@1;)
        local.get 0
        i32.const -4
        i32.add
        i32.load
        local.tee 3
        i32.const 3
        i32.and
        i32.const 1
        i32.eq
        br_if 1 (;@1;)
        local.get 1
        local.get 3
        i32.const -8
        i32.and
        local.tee 0
        i32.add
        local.set 4
        block  ;; label = @3
          local.get 3
          i32.const 1
          i32.and
          br_if 0 (;@3;)
          local.get 3
          i32.const 2
          i32.and
          i32.eqz
          br_if 1 (;@2;)
          local.get 1
          local.get 1
          i32.load
          local.tee 5
          i32.sub
          local.tee 1
          local.get 2
          i32.lt_u
          br_if 2 (;@1;)
          local.get 5
          local.get 0
          i32.add
          local.set 0
          block  ;; label = @4
            local.get 1
            i32.const 0
            i32.load offset=75376
            i32.eq
            br_if 0 (;@4;)
            local.get 1
            i32.load offset=12
            local.set 3
            block  ;; label = @5
              local.get 5
              i32.const 255
              i32.gt_u
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 1
                i32.load offset=8
                local.tee 6
                local.get 5
                i32.const 3
                i32.shr_u
                local.tee 7
                i32.const 3
                i32.shl
                i32.const 75396
                i32.add
                local.tee 5
                i32.eq
                br_if 0 (;@6;)
                local.get 6
                local.get 2
                i32.lt_u
                br_if 5 (;@1;)
                local.get 6
                i32.load offset=12
                local.get 1
                i32.ne
                br_if 5 (;@1;)
              end
              block  ;; label = @6
                local.get 3
                local.get 6
                i32.ne
                br_if 0 (;@6;)
                i32.const 0
                i32.const 0
                i32.load offset=75356
                i32.const -2
                local.get 7
                i32.rotl
                i32.and
                i32.store offset=75356
                br 3 (;@3;)
              end
              block  ;; label = @6
                local.get 3
                local.get 5
                i32.eq
                br_if 0 (;@6;)
                local.get 3
                local.get 2
                i32.lt_u
                br_if 5 (;@1;)
                local.get 3
                i32.load offset=8
                local.get 1
                i32.ne
                br_if 5 (;@1;)
              end
              local.get 6
              local.get 3
              i32.store offset=12
              local.get 3
              local.get 6
              i32.store offset=8
              br 2 (;@3;)
            end
            local.get 1
            i32.load offset=24
            local.set 8
            block  ;; label = @5
              block  ;; label = @6
                local.get 3
                local.get 1
                i32.eq
                br_if 0 (;@6;)
                local.get 1
                i32.load offset=8
                local.tee 5
                local.get 2
                i32.lt_u
                br_if 5 (;@1;)
                local.get 5
                i32.load offset=12
                local.get 1
                i32.ne
                br_if 5 (;@1;)
                local.get 3
                i32.load offset=8
                local.get 1
                i32.ne
                br_if 5 (;@1;)
                local.get 5
                local.get 3
                i32.store offset=12
                local.get 3
                local.get 5
                i32.store offset=8
                br 1 (;@5;)
              end
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 1
                    i32.load offset=20
                    local.tee 5
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 1
                    i32.const 20
                    i32.add
                    local.set 6
                    br 1 (;@7;)
                  end
                  local.get 1
                  i32.load offset=16
                  local.tee 5
                  i32.eqz
                  br_if 1 (;@6;)
                  local.get 1
                  i32.const 16
                  i32.add
                  local.set 6
                end
                loop  ;; label = @7
                  local.get 6
                  local.set 7
                  local.get 5
                  local.tee 3
                  i32.const 20
                  i32.add
                  local.set 6
                  local.get 3
                  i32.load offset=20
                  local.tee 5
                  br_if 0 (;@7;)
                  local.get 3
                  i32.const 16
                  i32.add
                  local.set 6
                  local.get 3
                  i32.load offset=16
                  local.tee 5
                  br_if 0 (;@7;)
                end
                local.get 7
                local.get 2
                i32.lt_u
                br_if 5 (;@1;)
                local.get 7
                i32.const 0
                i32.store
                br 1 (;@5;)
              end
              i32.const 0
              local.set 3
            end
            local.get 8
            i32.eqz
            br_if 1 (;@3;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 1
                local.get 1
                i32.load offset=28
                local.tee 6
                i32.const 2
                i32.shl
                i32.const 75660
                i32.add
                local.tee 5
                i32.load
                i32.ne
                br_if 0 (;@6;)
                local.get 5
                local.get 3
                i32.store
                local.get 3
                br_if 1 (;@5;)
                i32.const 0
                i32.const 0
                i32.load offset=75360
                i32.const -2
                local.get 6
                i32.rotl
                i32.and
                i32.store offset=75360
                br 3 (;@3;)
              end
              local.get 8
              local.get 2
              i32.lt_u
              br_if 4 (;@1;)
              block  ;; label = @6
                block  ;; label = @7
                  local.get 8
                  i32.load offset=16
                  local.get 1
                  i32.ne
                  br_if 0 (;@7;)
                  local.get 8
                  local.get 3
                  i32.store offset=16
                  br 1 (;@6;)
                end
                local.get 8
                local.get 3
                i32.store offset=20
              end
              local.get 3
              i32.eqz
              br_if 2 (;@3;)
            end
            local.get 3
            local.get 2
            i32.lt_u
            br_if 3 (;@1;)
            local.get 3
            local.get 8
            i32.store offset=24
            block  ;; label = @5
              local.get 1
              i32.load offset=16
              local.tee 5
              i32.eqz
              br_if 0 (;@5;)
              local.get 5
              local.get 2
              i32.lt_u
              br_if 4 (;@1;)
              local.get 3
              local.get 5
              i32.store offset=16
              local.get 5
              local.get 3
              i32.store offset=24
            end
            local.get 1
            i32.load offset=20
            local.tee 5
            i32.eqz
            br_if 1 (;@3;)
            local.get 5
            local.get 2
            i32.lt_u
            br_if 3 (;@1;)
            local.get 3
            local.get 5
            i32.store offset=20
            local.get 5
            local.get 3
            i32.store offset=24
            br 1 (;@3;)
          end
          local.get 4
          i32.load offset=4
          local.tee 3
          i32.const 3
          i32.and
          i32.const 3
          i32.ne
          br_if 0 (;@3;)
          i32.const 0
          local.get 0
          i32.store offset=75364
          local.get 4
          local.get 3
          i32.const -2
          i32.and
          i32.store offset=4
          local.get 1
          local.get 0
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 4
          local.get 0
          i32.store
          return
        end
        local.get 1
        local.get 4
        i32.ge_u
        br_if 1 (;@1;)
        local.get 4
        i32.load offset=4
        local.tee 7
        i32.const 1
        i32.and
        i32.eqz
        br_if 1 (;@1;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 7
            i32.const 2
            i32.and
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 4
              i32.const 0
              i32.load offset=75380
              i32.ne
              br_if 0 (;@5;)
              i32.const 0
              local.get 1
              i32.store offset=75380
              i32.const 0
              i32.const 0
              i32.load offset=75368
              local.get 0
              i32.add
              local.tee 0
              i32.store offset=75368
              local.get 1
              local.get 0
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 1
              i32.const 0
              i32.load offset=75376
              i32.ne
              br_if 3 (;@2;)
              i32.const 0
              i32.const 0
              i32.store offset=75364
              i32.const 0
              i32.const 0
              i32.store offset=75376
              return
            end
            block  ;; label = @5
              local.get 4
              i32.const 0
              i32.load offset=75376
              local.tee 9
              i32.ne
              br_if 0 (;@5;)
              i32.const 0
              local.get 1
              i32.store offset=75376
              i32.const 0
              i32.const 0
              i32.load offset=75364
              local.get 0
              i32.add
              local.tee 0
              i32.store offset=75364
              local.get 1
              local.get 0
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 1
              local.get 0
              i32.add
              local.get 0
              i32.store
              return
            end
            local.get 4
            i32.load offset=12
            local.set 3
            block  ;; label = @5
              block  ;; label = @6
                local.get 7
                i32.const 255
                i32.gt_u
                br_if 0 (;@6;)
                block  ;; label = @7
                  local.get 4
                  i32.load offset=8
                  local.tee 5
                  local.get 7
                  i32.const 3
                  i32.shr_u
                  local.tee 8
                  i32.const 3
                  i32.shl
                  i32.const 75396
                  i32.add
                  local.tee 6
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 5
                  local.get 2
                  i32.lt_u
                  br_if 6 (;@1;)
                  local.get 5
                  i32.load offset=12
                  local.get 4
                  i32.ne
                  br_if 6 (;@1;)
                end
                block  ;; label = @7
                  local.get 3
                  local.get 5
                  i32.ne
                  br_if 0 (;@7;)
                  i32.const 0
                  i32.const 0
                  i32.load offset=75356
                  i32.const -2
                  local.get 8
                  i32.rotl
                  i32.and
                  i32.store offset=75356
                  br 2 (;@5;)
                end
                block  ;; label = @7
                  local.get 3
                  local.get 6
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 3
                  local.get 2
                  i32.lt_u
                  br_if 6 (;@1;)
                  local.get 3
                  i32.load offset=8
                  local.get 4
                  i32.ne
                  br_if 6 (;@1;)
                end
                local.get 5
                local.get 3
                i32.store offset=12
                local.get 3
                local.get 5
                i32.store offset=8
                br 1 (;@5;)
              end
              local.get 4
              i32.load offset=24
              local.set 10
              block  ;; label = @6
                block  ;; label = @7
                  local.get 3
                  local.get 4
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 4
                  i32.load offset=8
                  local.tee 5
                  local.get 2
                  i32.lt_u
                  br_if 6 (;@1;)
                  local.get 5
                  i32.load offset=12
                  local.get 4
                  i32.ne
                  br_if 6 (;@1;)
                  local.get 3
                  i32.load offset=8
                  local.get 4
                  i32.ne
                  br_if 6 (;@1;)
                  local.get 5
                  local.get 3
                  i32.store offset=12
                  local.get 3
                  local.get 5
                  i32.store offset=8
                  br 1 (;@6;)
                end
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 4
                      i32.load offset=20
                      local.tee 5
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 4
                      i32.const 20
                      i32.add
                      local.set 6
                      br 1 (;@8;)
                    end
                    local.get 4
                    i32.load offset=16
                    local.tee 5
                    i32.eqz
                    br_if 1 (;@7;)
                    local.get 4
                    i32.const 16
                    i32.add
                    local.set 6
                  end
                  loop  ;; label = @8
                    local.get 6
                    local.set 8
                    local.get 5
                    local.tee 3
                    i32.const 20
                    i32.add
                    local.set 6
                    local.get 3
                    i32.load offset=20
                    local.tee 5
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 16
                    i32.add
                    local.set 6
                    local.get 3
                    i32.load offset=16
                    local.tee 5
                    br_if 0 (;@8;)
                  end
                  local.get 8
                  local.get 2
                  i32.lt_u
                  br_if 6 (;@1;)
                  local.get 8
                  i32.const 0
                  i32.store
                  br 1 (;@6;)
                end
                i32.const 0
                local.set 3
              end
              local.get 10
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                block  ;; label = @7
                  local.get 4
                  local.get 4
                  i32.load offset=28
                  local.tee 6
                  i32.const 2
                  i32.shl
                  i32.const 75660
                  i32.add
                  local.tee 5
                  i32.load
                  i32.ne
                  br_if 0 (;@7;)
                  local.get 5
                  local.get 3
                  i32.store
                  local.get 3
                  br_if 1 (;@6;)
                  i32.const 0
                  i32.const 0
                  i32.load offset=75360
                  i32.const -2
                  local.get 6
                  i32.rotl
                  i32.and
                  i32.store offset=75360
                  br 2 (;@5;)
                end
                local.get 10
                local.get 2
                i32.lt_u
                br_if 5 (;@1;)
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 10
                    i32.load offset=16
                    local.get 4
                    i32.ne
                    br_if 0 (;@8;)
                    local.get 10
                    local.get 3
                    i32.store offset=16
                    br 1 (;@7;)
                  end
                  local.get 10
                  local.get 3
                  i32.store offset=20
                end
                local.get 3
                i32.eqz
                br_if 1 (;@5;)
              end
              local.get 3
              local.get 2
              i32.lt_u
              br_if 4 (;@1;)
              local.get 3
              local.get 10
              i32.store offset=24
              block  ;; label = @6
                local.get 4
                i32.load offset=16
                local.tee 5
                i32.eqz
                br_if 0 (;@6;)
                local.get 5
                local.get 2
                i32.lt_u
                br_if 5 (;@1;)
                local.get 3
                local.get 5
                i32.store offset=16
                local.get 5
                local.get 3
                i32.store offset=24
              end
              local.get 4
              i32.load offset=20
              local.tee 5
              i32.eqz
              br_if 0 (;@5;)
              local.get 5
              local.get 2
              i32.lt_u
              br_if 4 (;@1;)
              local.get 3
              local.get 5
              i32.store offset=20
              local.get 5
              local.get 3
              i32.store offset=24
            end
            local.get 1
            local.get 7
            i32.const -8
            i32.and
            local.get 0
            i32.add
            local.tee 0
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 1
            local.get 0
            i32.add
            local.get 0
            i32.store
            local.get 1
            local.get 9
            i32.ne
            br_if 1 (;@3;)
            i32.const 0
            local.get 0
            i32.store offset=75364
            return
          end
          local.get 4
          local.get 7
          i32.const -2
          i32.and
          i32.store offset=4
          local.get 1
          local.get 0
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 1
          local.get 0
          i32.add
          local.get 0
          i32.store
        end
        block  ;; label = @3
          local.get 0
          i32.const 255
          i32.gt_u
          br_if 0 (;@3;)
          local.get 0
          i32.const -8
          i32.and
          i32.const 75396
          i32.add
          local.set 3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load offset=75356
              local.tee 5
              i32.const 1
              local.get 0
              i32.const 3
              i32.shr_u
              i32.shl
              local.tee 0
              i32.and
              br_if 0 (;@5;)
              i32.const 0
              local.get 5
              local.get 0
              i32.or
              i32.store offset=75356
              local.get 3
              local.set 0
              br 1 (;@4;)
            end
            local.get 3
            i32.load offset=8
            local.tee 0
            local.get 2
            i32.lt_u
            br_if 3 (;@1;)
          end
          local.get 3
          local.get 1
          i32.store offset=8
          local.get 0
          local.get 1
          i32.store offset=12
          local.get 1
          local.get 3
          i32.store offset=12
          local.get 1
          local.get 0
          i32.store offset=8
          return
        end
        i32.const 31
        local.set 3
        block  ;; label = @3
          local.get 0
          i32.const 16777215
          i32.gt_u
          br_if 0 (;@3;)
          local.get 0
          i32.const 38
          local.get 0
          i32.const 8
          i32.shr_u
          i32.clz
          local.tee 3
          i32.sub
          i32.shr_u
          i32.const 1
          i32.and
          local.get 3
          i32.const 1
          i32.shl
          i32.sub
          i32.const 62
          i32.add
          local.set 3
        end
        local.get 1
        local.get 3
        i32.store offset=28
        local.get 1
        i64.const 0
        i64.store offset=16 align=4
        local.get 3
        i32.const 2
        i32.shl
        i32.const 75660
        i32.add
        local.set 6
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                i32.const 0
                i32.load offset=75360
                local.tee 5
                i32.const 1
                local.get 3
                i32.shl
                local.tee 4
                i32.and
                br_if 0 (;@6;)
                i32.const 0
                local.get 5
                local.get 4
                i32.or
                i32.store offset=75360
                local.get 6
                local.get 1
                i32.store
                i32.const 8
                local.set 0
                i32.const 24
                local.set 3
                br 1 (;@5;)
              end
              local.get 0
              i32.const 0
              i32.const 25
              local.get 3
              i32.const 1
              i32.shr_u
              i32.sub
              local.get 3
              i32.const 31
              i32.eq
              select
              i32.shl
              local.set 3
              local.get 6
              i32.load
              local.set 6
              loop  ;; label = @6
                local.get 6
                local.tee 5
                i32.load offset=4
                i32.const -8
                i32.and
                local.get 0
                i32.eq
                br_if 2 (;@4;)
                local.get 3
                i32.const 29
                i32.shr_u
                local.set 6
                local.get 3
                i32.const 1
                i32.shl
                local.set 3
                local.get 5
                local.get 6
                i32.const 4
                i32.and
                i32.add
                local.tee 4
                i32.load offset=16
                local.tee 6
                br_if 0 (;@6;)
              end
              local.get 4
              i32.const 16
              i32.add
              local.tee 0
              local.get 2
              i32.lt_u
              br_if 4 (;@1;)
              local.get 0
              local.get 1
              i32.store
              i32.const 8
              local.set 0
              i32.const 24
              local.set 3
              local.get 5
              local.set 6
            end
            local.get 1
            local.set 5
            local.get 1
            local.set 4
            br 1 (;@3;)
          end
          local.get 5
          local.get 2
          i32.lt_u
          br_if 2 (;@1;)
          local.get 5
          i32.load offset=8
          local.tee 6
          local.get 2
          i32.lt_u
          br_if 2 (;@1;)
          local.get 6
          local.get 1
          i32.store offset=12
          local.get 5
          local.get 1
          i32.store offset=8
          i32.const 0
          local.set 4
          i32.const 24
          local.set 0
          i32.const 8
          local.set 3
        end
        local.get 1
        local.get 3
        i32.add
        local.get 6
        i32.store
        local.get 1
        local.get 5
        i32.store offset=12
        local.get 1
        local.get 0
        i32.add
        local.get 4
        i32.store
        i32.const 0
        i32.const 0
        i32.load offset=75388
        i32.const -1
        i32.add
        local.tee 1
        i32.const -1
        local.get 1
        select
        i32.store offset=75388
      end
      return
    end
    call $abort
    unreachable)
  (func $emscripten_builtin_realloc (type 6) (param i32 i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      br_if 0 (;@1;)
      local.get 1
      call $emscripten_builtin_malloc
      return
    end
    block  ;; label = @1
      local.get 1
      i32.const -64
      i32.lt_u
      br_if 0 (;@1;)
      call $__errno_location
      i32.const 48
      i32.store
      i32.const 0
      return
    end
    block  ;; label = @1
      local.get 0
      i32.const -8
      i32.add
      i32.const 16
      local.get 1
      i32.const 11
      i32.add
      i32.const -8
      i32.and
      local.get 1
      i32.const 11
      i32.lt_u
      select
      call $try_realloc_chunk
      local.tee 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      i32.const 8
      i32.add
      return
    end
    block  ;; label = @1
      local.get 1
      call $emscripten_builtin_malloc
      local.tee 2
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 2
    local.get 0
    i32.const -4
    i32.const -8
    local.get 0
    i32.const -4
    i32.add
    i32.load
    local.tee 3
    i32.const 3
    i32.and
    select
    local.get 3
    i32.const -8
    i32.and
    i32.add
    local.tee 3
    local.get 1
    local.get 3
    local.get 1
    i32.lt_u
    select
    call $__memcpy
    drop
    local.get 0
    call $emscripten_builtin_free
    local.get 2)
  (func $try_realloc_chunk (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.const 0
        i32.load offset=75372
        local.tee 2
        i32.lt_u
        br_if 0 (;@2;)
        local.get 0
        i32.load offset=4
        local.tee 3
        i32.const 3
        i32.and
        local.tee 4
        i32.const 1
        i32.eq
        br_if 0 (;@2;)
        local.get 3
        i32.const -8
        i32.and
        local.tee 5
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        local.get 5
        i32.add
        local.tee 6
        i32.load offset=4
        local.tee 7
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 4
          br_if 0 (;@3;)
          i32.const 0
          local.set 4
          local.get 1
          i32.const 256
          i32.lt_u
          br_if 2 (;@1;)
          block  ;; label = @4
            local.get 5
            local.get 1
            i32.const 4
            i32.add
            i32.lt_u
            br_if 0 (;@4;)
            local.get 0
            local.set 4
            local.get 5
            local.get 1
            i32.sub
            i32.const 0
            i32.load offset=75836
            i32.const 1
            i32.shl
            i32.le_u
            br_if 3 (;@1;)
          end
          i32.const 0
          local.set 4
          br 2 (;@1;)
        end
        block  ;; label = @3
          local.get 5
          local.get 1
          i32.lt_u
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 5
            local.get 1
            i32.sub
            local.tee 5
            i32.const 16
            i32.lt_u
            br_if 0 (;@4;)
            local.get 0
            local.get 1
            local.get 3
            i32.const 1
            i32.and
            i32.or
            i32.const 2
            i32.or
            i32.store offset=4
            local.get 0
            local.get 1
            i32.add
            local.tee 1
            local.get 5
            i32.const 3
            i32.or
            i32.store offset=4
            local.get 6
            local.get 6
            i32.load offset=4
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 1
            local.get 5
            call $dispose_chunk
          end
          local.get 0
          return
        end
        i32.const 0
        local.set 4
        block  ;; label = @3
          local.get 6
          i32.const 0
          i32.load offset=75380
          i32.ne
          br_if 0 (;@3;)
          i32.const 0
          i32.load offset=75368
          local.get 5
          i32.add
          local.tee 5
          local.get 1
          i32.le_u
          br_if 2 (;@1;)
          local.get 0
          local.get 1
          local.get 3
          i32.const 1
          i32.and
          i32.or
          i32.const 2
          i32.or
          i32.store offset=4
          local.get 0
          local.get 1
          i32.add
          local.tee 3
          local.get 5
          local.get 1
          i32.sub
          local.tee 5
          i32.const 1
          i32.or
          i32.store offset=4
          i32.const 0
          local.get 5
          i32.store offset=75368
          i32.const 0
          local.get 3
          i32.store offset=75380
          local.get 0
          return
        end
        block  ;; label = @3
          local.get 6
          i32.const 0
          i32.load offset=75376
          i32.ne
          br_if 0 (;@3;)
          i32.const 0
          local.set 4
          i32.const 0
          i32.load offset=75364
          local.get 5
          i32.add
          local.tee 5
          local.get 1
          i32.lt_u
          br_if 2 (;@1;)
          block  ;; label = @4
            block  ;; label = @5
              local.get 5
              local.get 1
              i32.sub
              local.tee 4
              i32.const 16
              i32.lt_u
              br_if 0 (;@5;)
              local.get 0
              local.get 1
              local.get 3
              i32.const 1
              i32.and
              i32.or
              i32.const 2
              i32.or
              i32.store offset=4
              local.get 0
              local.get 1
              i32.add
              local.tee 1
              local.get 4
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 0
              local.get 5
              i32.add
              local.tee 5
              local.get 4
              i32.store
              local.get 5
              local.get 5
              i32.load offset=4
              i32.const -2
              i32.and
              i32.store offset=4
              br 1 (;@4;)
            end
            local.get 0
            local.get 3
            i32.const 1
            i32.and
            local.get 5
            i32.or
            i32.const 2
            i32.or
            i32.store offset=4
            local.get 0
            local.get 5
            i32.add
            local.tee 5
            local.get 5
            i32.load offset=4
            i32.const 1
            i32.or
            i32.store offset=4
            i32.const 0
            local.set 4
            i32.const 0
            local.set 1
          end
          i32.const 0
          local.get 1
          i32.store offset=75376
          i32.const 0
          local.get 4
          i32.store offset=75364
          local.get 0
          return
        end
        i32.const 0
        local.set 4
        local.get 7
        i32.const 2
        i32.and
        br_if 1 (;@1;)
        local.get 7
        i32.const -8
        i32.and
        local.get 5
        i32.add
        local.tee 8
        local.get 1
        i32.lt_u
        br_if 1 (;@1;)
        local.get 6
        i32.load offset=12
        local.set 5
        block  ;; label = @3
          block  ;; label = @4
            local.get 7
            i32.const 255
            i32.gt_u
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 6
              i32.load offset=8
              local.tee 4
              local.get 7
              i32.const 3
              i32.shr_u
              local.tee 9
              i32.const 3
              i32.shl
              i32.const 75396
              i32.add
              local.tee 7
              i32.eq
              br_if 0 (;@5;)
              local.get 4
              local.get 2
              i32.lt_u
              br_if 3 (;@2;)
              local.get 4
              i32.load offset=12
              local.get 6
              i32.ne
              br_if 3 (;@2;)
            end
            block  ;; label = @5
              local.get 5
              local.get 4
              i32.ne
              br_if 0 (;@5;)
              i32.const 0
              i32.const 0
              i32.load offset=75356
              i32.const -2
              local.get 9
              i32.rotl
              i32.and
              i32.store offset=75356
              br 2 (;@3;)
            end
            block  ;; label = @5
              local.get 5
              local.get 7
              i32.eq
              br_if 0 (;@5;)
              local.get 5
              local.get 2
              i32.lt_u
              br_if 3 (;@2;)
              local.get 5
              i32.load offset=8
              local.get 6
              i32.ne
              br_if 3 (;@2;)
            end
            local.get 4
            local.get 5
            i32.store offset=12
            local.get 5
            local.get 4
            i32.store offset=8
            br 1 (;@3;)
          end
          local.get 6
          i32.load offset=24
          local.set 10
          block  ;; label = @4
            block  ;; label = @5
              local.get 5
              local.get 6
              i32.eq
              br_if 0 (;@5;)
              local.get 6
              i32.load offset=8
              local.tee 4
              local.get 2
              i32.lt_u
              br_if 3 (;@2;)
              local.get 4
              i32.load offset=12
              local.get 6
              i32.ne
              br_if 3 (;@2;)
              local.get 5
              i32.load offset=8
              local.get 6
              i32.ne
              br_if 3 (;@2;)
              local.get 4
              local.get 5
              i32.store offset=12
              local.get 5
              local.get 4
              i32.store offset=8
              br 1 (;@4;)
            end
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 6
                  i32.load offset=20
                  local.tee 4
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 6
                  i32.const 20
                  i32.add
                  local.set 7
                  br 1 (;@6;)
                end
                local.get 6
                i32.load offset=16
                local.tee 4
                i32.eqz
                br_if 1 (;@5;)
                local.get 6
                i32.const 16
                i32.add
                local.set 7
              end
              loop  ;; label = @6
                local.get 7
                local.set 9
                local.get 4
                local.tee 5
                i32.const 20
                i32.add
                local.set 7
                local.get 5
                i32.load offset=20
                local.tee 4
                br_if 0 (;@6;)
                local.get 5
                i32.const 16
                i32.add
                local.set 7
                local.get 5
                i32.load offset=16
                local.tee 4
                br_if 0 (;@6;)
              end
              local.get 9
              local.get 2
              i32.lt_u
              br_if 3 (;@2;)
              local.get 9
              i32.const 0
              i32.store
              br 1 (;@4;)
            end
            i32.const 0
            local.set 5
          end
          local.get 10
          i32.eqz
          br_if 0 (;@3;)
          block  ;; label = @4
            block  ;; label = @5
              local.get 6
              local.get 6
              i32.load offset=28
              local.tee 7
              i32.const 2
              i32.shl
              i32.const 75660
              i32.add
              local.tee 4
              i32.load
              i32.ne
              br_if 0 (;@5;)
              local.get 4
              local.get 5
              i32.store
              local.get 5
              br_if 1 (;@4;)
              i32.const 0
              i32.const 0
              i32.load offset=75360
              i32.const -2
              local.get 7
              i32.rotl
              i32.and
              i32.store offset=75360
              br 2 (;@3;)
            end
            local.get 10
            local.get 2
            i32.lt_u
            br_if 2 (;@2;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 10
                i32.load offset=16
                local.get 6
                i32.ne
                br_if 0 (;@6;)
                local.get 10
                local.get 5
                i32.store offset=16
                br 1 (;@5;)
              end
              local.get 10
              local.get 5
              i32.store offset=20
            end
            local.get 5
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 5
          local.get 2
          i32.lt_u
          br_if 1 (;@2;)
          local.get 5
          local.get 10
          i32.store offset=24
          block  ;; label = @4
            local.get 6
            i32.load offset=16
            local.tee 4
            i32.eqz
            br_if 0 (;@4;)
            local.get 4
            local.get 2
            i32.lt_u
            br_if 2 (;@2;)
            local.get 5
            local.get 4
            i32.store offset=16
            local.get 4
            local.get 5
            i32.store offset=24
          end
          local.get 6
          i32.load offset=20
          local.tee 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          local.get 2
          i32.lt_u
          br_if 1 (;@2;)
          local.get 5
          local.get 4
          i32.store offset=20
          local.get 4
          local.get 5
          i32.store offset=24
        end
        block  ;; label = @3
          local.get 8
          local.get 1
          i32.sub
          local.tee 5
          i32.const 15
          i32.gt_u
          br_if 0 (;@3;)
          local.get 0
          local.get 3
          i32.const 1
          i32.and
          local.get 8
          i32.or
          i32.const 2
          i32.or
          i32.store offset=4
          local.get 0
          local.get 8
          i32.add
          local.tee 5
          local.get 5
          i32.load offset=4
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 0
          return
        end
        local.get 0
        local.get 1
        local.get 3
        i32.const 1
        i32.and
        i32.or
        i32.const 2
        i32.or
        i32.store offset=4
        local.get 0
        local.get 1
        i32.add
        local.tee 1
        local.get 5
        i32.const 3
        i32.or
        i32.store offset=4
        local.get 0
        local.get 8
        i32.add
        local.tee 3
        local.get 3
        i32.load offset=4
        i32.const 1
        i32.or
        i32.store offset=4
        local.get 1
        local.get 5
        call $dispose_chunk
        local.get 0
        return
      end
      call $abort
      unreachable
    end
    local.get 4)
  (func $dispose_chunk (type 4) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    local.get 0
    local.get 1
    i32.add
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load offset=4
            local.tee 3
            i32.const 1
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            i32.load offset=75372
            local.set 4
            br 1 (;@3;)
          end
          local.get 3
          i32.const 2
          i32.and
          i32.eqz
          br_if 1 (;@2;)
          local.get 0
          local.get 0
          i32.load
          local.tee 5
          i32.sub
          local.tee 0
          i32.const 0
          i32.load offset=75372
          local.tee 4
          i32.lt_u
          br_if 2 (;@1;)
          local.get 5
          local.get 1
          i32.add
          local.set 1
          block  ;; label = @4
            local.get 0
            i32.const 0
            i32.load offset=75376
            i32.eq
            br_if 0 (;@4;)
            local.get 0
            i32.load offset=12
            local.set 3
            block  ;; label = @5
              local.get 5
              i32.const 255
              i32.gt_u
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 0
                i32.load offset=8
                local.tee 6
                local.get 5
                i32.const 3
                i32.shr_u
                local.tee 7
                i32.const 3
                i32.shl
                i32.const 75396
                i32.add
                local.tee 5
                i32.eq
                br_if 0 (;@6;)
                local.get 6
                local.get 4
                i32.lt_u
                br_if 5 (;@1;)
                local.get 6
                i32.load offset=12
                local.get 0
                i32.ne
                br_if 5 (;@1;)
              end
              block  ;; label = @6
                local.get 3
                local.get 6
                i32.ne
                br_if 0 (;@6;)
                i32.const 0
                i32.const 0
                i32.load offset=75356
                i32.const -2
                local.get 7
                i32.rotl
                i32.and
                i32.store offset=75356
                br 3 (;@3;)
              end
              block  ;; label = @6
                local.get 3
                local.get 5
                i32.eq
                br_if 0 (;@6;)
                local.get 3
                local.get 4
                i32.lt_u
                br_if 5 (;@1;)
                local.get 3
                i32.load offset=8
                local.get 0
                i32.ne
                br_if 5 (;@1;)
              end
              local.get 6
              local.get 3
              i32.store offset=12
              local.get 3
              local.get 6
              i32.store offset=8
              br 2 (;@3;)
            end
            local.get 0
            i32.load offset=24
            local.set 8
            block  ;; label = @5
              block  ;; label = @6
                local.get 3
                local.get 0
                i32.eq
                br_if 0 (;@6;)
                local.get 0
                i32.load offset=8
                local.tee 5
                local.get 4
                i32.lt_u
                br_if 5 (;@1;)
                local.get 5
                i32.load offset=12
                local.get 0
                i32.ne
                br_if 5 (;@1;)
                local.get 3
                i32.load offset=8
                local.get 0
                i32.ne
                br_if 5 (;@1;)
                local.get 5
                local.get 3
                i32.store offset=12
                local.get 3
                local.get 5
                i32.store offset=8
                br 1 (;@5;)
              end
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 0
                    i32.load offset=20
                    local.tee 5
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 0
                    i32.const 20
                    i32.add
                    local.set 6
                    br 1 (;@7;)
                  end
                  local.get 0
                  i32.load offset=16
                  local.tee 5
                  i32.eqz
                  br_if 1 (;@6;)
                  local.get 0
                  i32.const 16
                  i32.add
                  local.set 6
                end
                loop  ;; label = @7
                  local.get 6
                  local.set 7
                  local.get 5
                  local.tee 3
                  i32.const 20
                  i32.add
                  local.set 6
                  local.get 3
                  i32.load offset=20
                  local.tee 5
                  br_if 0 (;@7;)
                  local.get 3
                  i32.const 16
                  i32.add
                  local.set 6
                  local.get 3
                  i32.load offset=16
                  local.tee 5
                  br_if 0 (;@7;)
                end
                local.get 7
                local.get 4
                i32.lt_u
                br_if 5 (;@1;)
                local.get 7
                i32.const 0
                i32.store
                br 1 (;@5;)
              end
              i32.const 0
              local.set 3
            end
            local.get 8
            i32.eqz
            br_if 1 (;@3;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                local.get 0
                i32.load offset=28
                local.tee 6
                i32.const 2
                i32.shl
                i32.const 75660
                i32.add
                local.tee 5
                i32.load
                i32.ne
                br_if 0 (;@6;)
                local.get 5
                local.get 3
                i32.store
                local.get 3
                br_if 1 (;@5;)
                i32.const 0
                i32.const 0
                i32.load offset=75360
                i32.const -2
                local.get 6
                i32.rotl
                i32.and
                i32.store offset=75360
                br 3 (;@3;)
              end
              local.get 8
              local.get 4
              i32.lt_u
              br_if 4 (;@1;)
              block  ;; label = @6
                block  ;; label = @7
                  local.get 8
                  i32.load offset=16
                  local.get 0
                  i32.ne
                  br_if 0 (;@7;)
                  local.get 8
                  local.get 3
                  i32.store offset=16
                  br 1 (;@6;)
                end
                local.get 8
                local.get 3
                i32.store offset=20
              end
              local.get 3
              i32.eqz
              br_if 2 (;@3;)
            end
            local.get 3
            local.get 4
            i32.lt_u
            br_if 3 (;@1;)
            local.get 3
            local.get 8
            i32.store offset=24
            block  ;; label = @5
              local.get 0
              i32.load offset=16
              local.tee 5
              i32.eqz
              br_if 0 (;@5;)
              local.get 5
              local.get 4
              i32.lt_u
              br_if 4 (;@1;)
              local.get 3
              local.get 5
              i32.store offset=16
              local.get 5
              local.get 3
              i32.store offset=24
            end
            local.get 0
            i32.load offset=20
            local.tee 5
            i32.eqz
            br_if 1 (;@3;)
            local.get 5
            local.get 4
            i32.lt_u
            br_if 3 (;@1;)
            local.get 3
            local.get 5
            i32.store offset=20
            local.get 5
            local.get 3
            i32.store offset=24
            br 1 (;@3;)
          end
          local.get 2
          i32.load offset=4
          local.tee 3
          i32.const 3
          i32.and
          i32.const 3
          i32.ne
          br_if 0 (;@3;)
          i32.const 0
          local.get 1
          i32.store offset=75364
          local.get 2
          local.get 3
          i32.const -2
          i32.and
          i32.store offset=4
          local.get 0
          local.get 1
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 2
          local.get 1
          i32.store
          return
        end
        local.get 2
        local.get 4
        i32.lt_u
        br_if 1 (;@1;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.load offset=4
            local.tee 8
            i32.const 2
            i32.and
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 2
              i32.const 0
              i32.load offset=75380
              i32.ne
              br_if 0 (;@5;)
              i32.const 0
              local.get 0
              i32.store offset=75380
              i32.const 0
              i32.const 0
              i32.load offset=75368
              local.get 1
              i32.add
              local.tee 1
              i32.store offset=75368
              local.get 0
              local.get 1
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 0
              i32.const 0
              i32.load offset=75376
              i32.ne
              br_if 3 (;@2;)
              i32.const 0
              i32.const 0
              i32.store offset=75364
              i32.const 0
              i32.const 0
              i32.store offset=75376
              return
            end
            block  ;; label = @5
              local.get 2
              i32.const 0
              i32.load offset=75376
              local.tee 9
              i32.ne
              br_if 0 (;@5;)
              i32.const 0
              local.get 0
              i32.store offset=75376
              i32.const 0
              i32.const 0
              i32.load offset=75364
              local.get 1
              i32.add
              local.tee 1
              i32.store offset=75364
              local.get 0
              local.get 1
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 0
              local.get 1
              i32.add
              local.get 1
              i32.store
              return
            end
            local.get 2
            i32.load offset=12
            local.set 3
            block  ;; label = @5
              block  ;; label = @6
                local.get 8
                i32.const 255
                i32.gt_u
                br_if 0 (;@6;)
                block  ;; label = @7
                  local.get 2
                  i32.load offset=8
                  local.tee 5
                  local.get 8
                  i32.const 3
                  i32.shr_u
                  local.tee 7
                  i32.const 3
                  i32.shl
                  i32.const 75396
                  i32.add
                  local.tee 6
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 5
                  local.get 4
                  i32.lt_u
                  br_if 6 (;@1;)
                  local.get 5
                  i32.load offset=12
                  local.get 2
                  i32.ne
                  br_if 6 (;@1;)
                end
                block  ;; label = @7
                  local.get 3
                  local.get 5
                  i32.ne
                  br_if 0 (;@7;)
                  i32.const 0
                  i32.const 0
                  i32.load offset=75356
                  i32.const -2
                  local.get 7
                  i32.rotl
                  i32.and
                  i32.store offset=75356
                  br 2 (;@5;)
                end
                block  ;; label = @7
                  local.get 3
                  local.get 6
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 3
                  local.get 4
                  i32.lt_u
                  br_if 6 (;@1;)
                  local.get 3
                  i32.load offset=8
                  local.get 2
                  i32.ne
                  br_if 6 (;@1;)
                end
                local.get 5
                local.get 3
                i32.store offset=12
                local.get 3
                local.get 5
                i32.store offset=8
                br 1 (;@5;)
              end
              local.get 2
              i32.load offset=24
              local.set 10
              block  ;; label = @6
                block  ;; label = @7
                  local.get 3
                  local.get 2
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 2
                  i32.load offset=8
                  local.tee 5
                  local.get 4
                  i32.lt_u
                  br_if 6 (;@1;)
                  local.get 5
                  i32.load offset=12
                  local.get 2
                  i32.ne
                  br_if 6 (;@1;)
                  local.get 3
                  i32.load offset=8
                  local.get 2
                  i32.ne
                  br_if 6 (;@1;)
                  local.get 5
                  local.get 3
                  i32.store offset=12
                  local.get 3
                  local.get 5
                  i32.store offset=8
                  br 1 (;@6;)
                end
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 2
                      i32.load offset=20
                      local.tee 5
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 2
                      i32.const 20
                      i32.add
                      local.set 6
                      br 1 (;@8;)
                    end
                    local.get 2
                    i32.load offset=16
                    local.tee 5
                    i32.eqz
                    br_if 1 (;@7;)
                    local.get 2
                    i32.const 16
                    i32.add
                    local.set 6
                  end
                  loop  ;; label = @8
                    local.get 6
                    local.set 7
                    local.get 5
                    local.tee 3
                    i32.const 20
                    i32.add
                    local.set 6
                    local.get 3
                    i32.load offset=20
                    local.tee 5
                    br_if 0 (;@8;)
                    local.get 3
                    i32.const 16
                    i32.add
                    local.set 6
                    local.get 3
                    i32.load offset=16
                    local.tee 5
                    br_if 0 (;@8;)
                  end
                  local.get 7
                  local.get 4
                  i32.lt_u
                  br_if 6 (;@1;)
                  local.get 7
                  i32.const 0
                  i32.store
                  br 1 (;@6;)
                end
                i32.const 0
                local.set 3
              end
              local.get 10
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                block  ;; label = @7
                  local.get 2
                  local.get 2
                  i32.load offset=28
                  local.tee 6
                  i32.const 2
                  i32.shl
                  i32.const 75660
                  i32.add
                  local.tee 5
                  i32.load
                  i32.ne
                  br_if 0 (;@7;)
                  local.get 5
                  local.get 3
                  i32.store
                  local.get 3
                  br_if 1 (;@6;)
                  i32.const 0
                  i32.const 0
                  i32.load offset=75360
                  i32.const -2
                  local.get 6
                  i32.rotl
                  i32.and
                  i32.store offset=75360
                  br 2 (;@5;)
                end
                local.get 10
                local.get 4
                i32.lt_u
                br_if 5 (;@1;)
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 10
                    i32.load offset=16
                    local.get 2
                    i32.ne
                    br_if 0 (;@8;)
                    local.get 10
                    local.get 3
                    i32.store offset=16
                    br 1 (;@7;)
                  end
                  local.get 10
                  local.get 3
                  i32.store offset=20
                end
                local.get 3
                i32.eqz
                br_if 1 (;@5;)
              end
              local.get 3
              local.get 4
              i32.lt_u
              br_if 4 (;@1;)
              local.get 3
              local.get 10
              i32.store offset=24
              block  ;; label = @6
                local.get 2
                i32.load offset=16
                local.tee 5
                i32.eqz
                br_if 0 (;@6;)
                local.get 5
                local.get 4
                i32.lt_u
                br_if 5 (;@1;)
                local.get 3
                local.get 5
                i32.store offset=16
                local.get 5
                local.get 3
                i32.store offset=24
              end
              local.get 2
              i32.load offset=20
              local.tee 5
              i32.eqz
              br_if 0 (;@5;)
              local.get 5
              local.get 4
              i32.lt_u
              br_if 4 (;@1;)
              local.get 3
              local.get 5
              i32.store offset=20
              local.get 5
              local.get 3
              i32.store offset=24
            end
            local.get 0
            local.get 8
            i32.const -8
            i32.and
            local.get 1
            i32.add
            local.tee 1
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 0
            local.get 1
            i32.add
            local.get 1
            i32.store
            local.get 0
            local.get 9
            i32.ne
            br_if 1 (;@3;)
            i32.const 0
            local.get 1
            i32.store offset=75364
            return
          end
          local.get 2
          local.get 8
          i32.const -2
          i32.and
          i32.store offset=4
          local.get 0
          local.get 1
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 0
          local.get 1
          i32.add
          local.get 1
          i32.store
        end
        block  ;; label = @3
          local.get 1
          i32.const 255
          i32.gt_u
          br_if 0 (;@3;)
          local.get 1
          i32.const -8
          i32.and
          i32.const 75396
          i32.add
          local.set 3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load offset=75356
              local.tee 5
              i32.const 1
              local.get 1
              i32.const 3
              i32.shr_u
              i32.shl
              local.tee 1
              i32.and
              br_if 0 (;@5;)
              i32.const 0
              local.get 5
              local.get 1
              i32.or
              i32.store offset=75356
              local.get 3
              local.set 1
              br 1 (;@4;)
            end
            local.get 3
            i32.load offset=8
            local.tee 1
            local.get 4
            i32.lt_u
            br_if 3 (;@1;)
          end
          local.get 3
          local.get 0
          i32.store offset=8
          local.get 1
          local.get 0
          i32.store offset=12
          local.get 0
          local.get 3
          i32.store offset=12
          local.get 0
          local.get 1
          i32.store offset=8
          return
        end
        i32.const 31
        local.set 3
        block  ;; label = @3
          local.get 1
          i32.const 16777215
          i32.gt_u
          br_if 0 (;@3;)
          local.get 1
          i32.const 38
          local.get 1
          i32.const 8
          i32.shr_u
          i32.clz
          local.tee 3
          i32.sub
          i32.shr_u
          i32.const 1
          i32.and
          local.get 3
          i32.const 1
          i32.shl
          i32.sub
          i32.const 62
          i32.add
          local.set 3
        end
        local.get 0
        local.get 3
        i32.store offset=28
        local.get 0
        i64.const 0
        i64.store offset=16 align=4
        local.get 3
        i32.const 2
        i32.shl
        i32.const 75660
        i32.add
        local.set 5
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 0
              i32.load offset=75360
              local.tee 6
              i32.const 1
              local.get 3
              i32.shl
              local.tee 2
              i32.and
              br_if 0 (;@5;)
              i32.const 0
              local.get 6
              local.get 2
              i32.or
              i32.store offset=75360
              local.get 5
              local.get 0
              i32.store
              local.get 0
              local.get 5
              i32.store offset=24
              br 1 (;@4;)
            end
            local.get 1
            i32.const 0
            i32.const 25
            local.get 3
            i32.const 1
            i32.shr_u
            i32.sub
            local.get 3
            i32.const 31
            i32.eq
            select
            i32.shl
            local.set 3
            local.get 5
            i32.load
            local.set 6
            loop  ;; label = @5
              local.get 6
              local.tee 5
              i32.load offset=4
              i32.const -8
              i32.and
              local.get 1
              i32.eq
              br_if 2 (;@3;)
              local.get 3
              i32.const 29
              i32.shr_u
              local.set 6
              local.get 3
              i32.const 1
              i32.shl
              local.set 3
              local.get 5
              local.get 6
              i32.const 4
              i32.and
              i32.add
              local.tee 2
              i32.load offset=16
              local.tee 6
              br_if 0 (;@5;)
            end
            local.get 2
            i32.const 16
            i32.add
            local.tee 1
            local.get 4
            i32.lt_u
            br_if 3 (;@1;)
            local.get 1
            local.get 0
            i32.store
            local.get 0
            local.get 5
            i32.store offset=24
          end
          local.get 0
          local.get 0
          i32.store offset=12
          local.get 0
          local.get 0
          i32.store offset=8
          return
        end
        local.get 5
        local.get 4
        i32.lt_u
        br_if 1 (;@1;)
        local.get 5
        i32.load offset=8
        local.tee 1
        local.get 4
        i32.lt_u
        br_if 1 (;@1;)
        local.get 1
        local.get 0
        i32.store offset=12
        local.get 5
        local.get 0
        i32.store offset=8
        local.get 0
        i32.const 0
        i32.store offset=24
        local.get 0
        local.get 5
        i32.store offset=12
        local.get 0
        local.get 1
        i32.store offset=8
      end
      return
    end
    call $abort
    unreachable)
  (func $emscripten_builtin_calloc (type 6) (param i32 i32) (result i32)
    (local i32 i64)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        br_if 0 (;@2;)
        i32.const 0
        local.set 2
        br 1 (;@1;)
      end
      local.get 0
      i64.extend_i32_u
      local.get 1
      i64.extend_i32_u
      i64.mul
      local.tee 3
      i32.wrap_i64
      local.set 2
      local.get 1
      local.get 0
      i32.or
      i32.const 65536
      i32.lt_u
      br_if 0 (;@1;)
      i32.const -1
      local.get 2
      local.get 3
      i64.const 32
      i64.shr_u
      i32.wrap_i64
      i32.const 0
      i32.ne
      select
      local.set 2
    end
    block  ;; label = @1
      local.get 2
      call $emscripten_builtin_malloc
      local.tee 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.const -4
      i32.add
      i32.load8_u
      i32.const 3
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      local.get 2
      call $__memset
      drop
    end
    local.get 0)
  (func $emscripten_get_heap_size (type 20) (result i32)
    memory.size
    i32.const 16
    i32.shl)
  (func $sbrk (type 8) (param i32) (result i32)
    (local i32 i32)
    i32.const 0
    i32.load offset=74852
    local.tee 1
    local.get 0
    i32.const 7
    i32.add
    i32.const -8
    i32.and
    local.tee 2
    i32.add
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          local.get 1
          i32.le_u
          br_if 1 (;@2;)
        end
        local.get 0
        call $emscripten_get_heap_size
        i32.le_u
        br_if 1 (;@1;)
        local.get 0
        call $emscripten_resize_heap
        br_if 1 (;@1;)
      end
      call $__errno_location
      i32.const 48
      i32.store
      i32.const -1
      return
    end
    i32.const 0
    local.get 0
    i32.store offset=74852
    local.get 1)
  (func $emscripten_stack_init (type 7)
    i32.const 65536
    global.set $__stack_base
    i32.const 0
    i32.const 15
    i32.add
    i32.const -16
    i32.and
    global.set $__stack_end)
  (func $emscripten_stack_get_free (type 20) (result i32)
    global.get $__stack_pointer
    global.get $__stack_end
    i32.sub)
  (func $emscripten_stack_get_base (type 20) (result i32)
    global.get $__stack_base)
  (func $emscripten_stack_get_end (type 20) (result i32)
    global.get $__stack_end)
  (func $__ashlti3 (type 30) (param i32 i64 i64 i32)
    (local i64)
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.const 64
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        local.get 3
        i32.const -64
        i32.add
        i64.extend_i32_u
        i64.shl
        local.set 2
        i64.const 0
        local.set 1
        br 1 (;@1;)
      end
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.const 64
      local.get 3
      i32.sub
      i64.extend_i32_u
      i64.shr_u
      local.get 2
      local.get 3
      i64.extend_i32_u
      local.tee 4
      i64.shl
      i64.or
      local.set 2
      local.get 1
      local.get 4
      i64.shl
      local.set 1
    end
    local.get 0
    local.get 1
    i64.store
    local.get 0
    local.get 2
    i64.store offset=8)
  (func $__lshrti3 (type 30) (param i32 i64 i64 i32)
    (local i64)
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.const 64
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 3
        i32.const -64
        i32.add
        i64.extend_i32_u
        i64.shr_u
        local.set 1
        i64.const 0
        local.set 2
        br 1 (;@1;)
      end
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      i32.const 64
      local.get 3
      i32.sub
      i64.extend_i32_u
      i64.shl
      local.get 1
      local.get 3
      i64.extend_i32_u
      local.tee 4
      i64.shr_u
      i64.or
      local.set 1
      local.get 2
      local.get 4
      i64.shr_u
      local.set 2
    end
    local.get 0
    local.get 1
    i64.store
    local.get 0
    local.get 2
    i64.store offset=8)
  (func $__trunctfdf2 (type 31) (param i64 i64) (result f64)
    (local i32 i64 i64 i32 i32 i32 i32)
    global.get $__stack_pointer
    i32.const 32
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 1
    i64.const 281474976710655
    i64.and
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i64.const 48
        i64.shr_u
        i64.const 32767
        i64.and
        local.tee 4
        i32.wrap_i64
        local.tee 5
        i32.const -15361
        i32.add
        i32.const 2045
        i32.gt_u
        br_if 0 (;@2;)
        local.get 0
        i64.const 60
        i64.shr_u
        local.get 3
        i64.const 4
        i64.shl
        i64.or
        local.set 3
        local.get 5
        i32.const -15360
        i32.add
        i64.extend_i32_u
        local.set 4
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i64.const 1152921504606846975
            i64.and
            local.tee 0
            i64.const 576460752303423489
            i64.lt_u
            br_if 0 (;@4;)
            local.get 3
            i64.const 1
            i64.add
            local.set 3
            br 1 (;@3;)
          end
          local.get 0
          i64.const 576460752303423488
          i64.ne
          br_if 0 (;@3;)
          local.get 3
          i64.const 1
          i64.and
          local.get 3
          i64.add
          local.set 3
        end
        i64.const 0
        local.get 3
        local.get 3
        i64.const 4503599627370495
        i64.gt_u
        local.tee 5
        select
        local.set 0
        local.get 5
        i64.extend_i32_u
        local.get 4
        i64.add
        local.set 3
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        local.get 3
        i64.or
        i64.eqz
        br_if 0 (;@2;)
        local.get 4
        i64.const 32767
        i64.ne
        br_if 0 (;@2;)
        local.get 0
        i64.const 60
        i64.shr_u
        local.get 3
        i64.const 4
        i64.shl
        i64.or
        i64.const 2251799813685248
        i64.or
        local.set 0
        i64.const 2047
        local.set 3
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 5
        i32.const 17406
        i32.le_u
        br_if 0 (;@2;)
        i64.const 2047
        local.set 3
        i64.const 0
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 15360
        i32.const 15361
        local.get 4
        i64.eqz
        local.tee 6
        select
        local.tee 7
        local.get 5
        i32.sub
        local.tee 8
        i32.const 112
        i32.le_s
        br_if 0 (;@2;)
        i64.const 0
        local.set 0
        i64.const 0
        local.set 3
        br 1 (;@1;)
      end
      local.get 2
      i32.const 16
      i32.add
      local.get 0
      local.get 3
      local.get 3
      i64.const 281474976710656
      i64.or
      local.get 6
      select
      local.tee 3
      i32.const 128
      local.get 8
      i32.sub
      call $__ashlti3
      local.get 2
      local.get 0
      local.get 3
      local.get 8
      call $__lshrti3
      local.get 2
      i64.load
      local.tee 3
      i64.const 60
      i64.shr_u
      local.get 2
      i64.load offset=8
      i64.const 4
      i64.shl
      i64.or
      local.set 0
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i64.const 1152921504606846975
          i64.and
          local.get 7
          local.get 5
          i32.ne
          local.get 2
          i64.load offset=16
          local.get 2
          i64.load offset=24
          i64.or
          i64.const 0
          i64.ne
          i32.and
          i64.extend_i32_u
          i64.or
          local.tee 3
          i64.const 576460752303423489
          i64.lt_u
          br_if 0 (;@3;)
          local.get 0
          i64.const 1
          i64.add
          local.set 0
          br 1 (;@2;)
        end
        local.get 3
        i64.const 576460752303423488
        i64.ne
        br_if 0 (;@2;)
        local.get 0
        i64.const 1
        i64.and
        local.get 0
        i64.add
        local.set 0
      end
      local.get 0
      i64.const 4503599627370496
      i64.xor
      local.get 0
      local.get 0
      i64.const 4503599627370495
      i64.gt_u
      local.tee 5
      select
      local.set 0
      local.get 5
      i64.extend_i32_u
      local.set 3
    end
    local.get 2
    i32.const 32
    i32.add
    global.set $__stack_pointer
    local.get 3
    i64.const 52
    i64.shl
    local.get 1
    i64.const -9223372036854775808
    i64.and
    i64.or
    local.get 0
    i64.or
    f64.reinterpret_i64)
  (func $_emscripten_stack_restore (type 1) (param i32)
    local.get 0
    global.set $__stack_pointer)
  (func $_emscripten_stack_alloc (type 8) (param i32) (result i32)
    (local i32 i32)
    global.get $__stack_pointer
    local.get 0
    i32.sub
    i32.const -16
    i32.and
    local.tee 1
    global.set $__stack_pointer
    local.get 1)
  (func $emscripten_stack_get_current (type 20) (result i32)
    global.get $__stack_pointer)
  (func $fflush (type 8) (param i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      br_if 0 (;@1;)
      i32.const 0
      local.set 1
      block  ;; label = @2
        i32.const 0
        i32.load offset=75152
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=75152
        call $fflush
        local.set 1
      end
      block  ;; label = @2
        i32.const 0
        i32.load offset=74848
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=74848
        call $fflush
        local.get 1
        i32.or
        local.set 1
      end
      block  ;; label = @2
        call $__ofl_lock
        i32.load
        local.tee 0
        i32.eqz
        br_if 0 (;@2;)
        loop  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.load offset=76
              i32.const 0
              i32.ge_s
              br_if 0 (;@5;)
              i32.const 1
              local.set 2
              br 1 (;@4;)
            end
            local.get 0
            call $__lockfile
            i32.eqz
            local.set 2
          end
          block  ;; label = @4
            local.get 0
            i32.load offset=20
            local.get 0
            i32.load offset=28
            i32.eq
            br_if 0 (;@4;)
            local.get 0
            call $fflush
            local.get 1
            i32.or
            local.set 1
          end
          block  ;; label = @4
            local.get 2
            br_if 0 (;@4;)
            local.get 0
            call $__unlockfile
          end
          local.get 0
          i32.load offset=56
          local.tee 0
          br_if 0 (;@3;)
        end
      end
      call $__ofl_unlock
      local.get 1
      return
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=76
        i32.const 0
        i32.ge_s
        br_if 0 (;@2;)
        i32.const 1
        local.set 2
        br 1 (;@1;)
      end
      local.get 0
      call $__lockfile
      i32.eqz
      local.set 2
    end
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load offset=20
          local.get 0
          i32.load offset=28
          i32.eq
          br_if 0 (;@3;)
          local.get 0
          i32.const 0
          i32.const 0
          local.get 0
          i32.load offset=36
          call_indirect (type 2)
          drop
          local.get 0
          i32.load offset=20
          br_if 0 (;@3;)
          i32.const -1
          local.set 1
          local.get 2
          i32.eqz
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        block  ;; label = @3
          local.get 0
          i32.load offset=4
          local.tee 1
          local.get 0
          i32.load offset=8
          local.tee 3
          i32.eq
          br_if 0 (;@3;)
          local.get 0
          local.get 1
          local.get 3
          i32.sub
          i64.extend_i32_s
          i32.const 1
          local.get 0
          i32.load offset=40
          call_indirect (type 5)
          drop
        end
        i32.const 0
        local.set 1
        local.get 0
        i32.const 0
        i32.store offset=28
        local.get 0
        i64.const 0
        i64.store offset=16
        local.get 0
        i64.const 0
        i64.store offset=4 align=4
        local.get 2
        br_if 1 (;@1;)
      end
      local.get 0
      call $__unlockfile
    end
    local.get 1)
  (func $__strerror_l (type 6) (param i32 i32) (result i32)
    i32.const 0
    local.get 0
    local.get 0
    i32.const 153
    i32.gt_u
    select
    i32.const 1
    i32.shl
    i32.const 74384
    i32.add
    i32.load16_u
    i32.const 72464
    i32.add)
  (func $strerror (type 8) (param i32) (result i32)
    local.get 0
    local.get 0
    call $__strerror_l)
  (table (;0;) 7 funcref)
  (memory (;0;) 258 258)
  (global $__stack_pointer (mut i32) (i32.const 65536))
  (global $__stack_end (mut i32) (i32.const 0))
  (global $__stack_base (mut i32) (i32.const 0))
  (global (;3;) i32 (i32.const 74856))
  (global (;4;) i32 (i32.const 74856))
  (global (;5;) i32 (i32.const 75114))
  (export "memory" (memory 0))
  (export "__wasm_call_ctors" (func $__wasm_call_ctors))
  (export "initialize" (func $initialize))
  (export "populateMsgHTML" (func $populateMsgHTML))
  (export "__indirect_function_table" (table 0))
  (export "renderHtml" (func $renderHtml))
  (export "renderText" (func $renderText))
  (export "addMsg" (func $addMsg))
  (export "editMsg" (func $editMsg))
  (export "deleteMsg" (func $deleteMsg))
  (export "__em_js__jsSanitize" (global 3))
  (export "fflush" (func $fflush))
  (export "strerror" (func $strerror))
  (export "emscripten_stack_get_end" (func $emscripten_stack_get_end))
  (export "emscripten_stack_get_base" (func $emscripten_stack_get_base))
  (export "emscripten_stack_init" (func $emscripten_stack_init))
  (export "emscripten_stack_get_free" (func $emscripten_stack_get_free))
  (export "_emscripten_stack_restore" (func $_emscripten_stack_restore))
  (export "_emscripten_stack_alloc" (func $_emscripten_stack_alloc))
  (export "emscripten_stack_get_current" (func $emscripten_stack_get_current))
  (export "__start_em_js" (global 4))
  (export "__stop_em_js" (global 5))
  (elem (;0;) (i32.const 1) func $fmt_fp $pop_arg_long_double $sn_write $__stdio_close $__stdio_write $__stdio_seek)
  (data $.rodata (i32.const 65536) "-+   0X0x\00-0X+0X 0X-0x+0x 0x\00nan\00inf\00NAN\00INF\00stuff?\00<div>%.*s</div>\00&quot;\00&lt;\00&gt;\00&amp;\00&#37;\00&#x27;\00.\00(null)\00TBL\00\00\00\00\fe\82+eG\15g@\00\00\00\00\00\008C\00\00\fa\feB.v\bf:;\9e\bc\9a\f7\0c\bd\bd\fd\ff\ff\ff\ff\df?<TUUUU\c5?\91+\17\cfUU\a5?\17\d0\a4g\11\11\81?\00\00\00\00\00\00\c8B\ef9\fa\feB.\e6?$\c4\82\ff\bd\bf\ce?\b5\f4\0c\d7\08k\ac?\ccPF\d2\ab\b2\83?\84:N\9b\e0\d7U?\00\00\00\00\00\00\00\00\00\00\00\00\00\00\f0?n\bf\88\1aO;\9b<53\fb\a9=\f6\ef?]\dc\d8\9c\13`q\bca\80w>\9a\ec\ef?\d1f\87\10z^\90\bc\85\7fn\e8\15\e3\ef?\13\f6g5R\d2\8c<t\85\15\d3\b0\d9\ef?\fa\8e\f9#\80\ce\8b\bc\de\f6\dd)k\d0\ef?a\c8\e6aN\f7`<\c8\9bu\18E\c7\ef?\99\d33[\e4\a3\90<\83\f3\c6\ca>\be\ef?m{\83]\a6\9a\97<\0f\89\f9lX\b5\ef?\fc\ef\fd\92\1a\b5\8e<\f7Gr+\92\ac\ef?\d1\9c/p=\be><\a2\d1\d32\ec\a3\ef?\0bn\90\894\03j\bc\1b\d3\fe\aff\9b\ef?\0e\bd/*RV\95\bcQ[\12\d0\01\93\ef?U\eaN\8c\ef\80P\bc\cc1l\c0\bd\8a\ef?\16\f4\d5\b9#\c9\91\bc\e0-\a9\ae\9a\82\ef?\afU\5c\e9\e3\d3\80<Q\8e\a5\c8\98z\ef?H\93\a5\ea\15\1b\80\bc{Q}<\b8r\ef?=2\deU\f0\1f\8f\bc\ea\8d\8c8\f9j\ef?\bfS\13?\8c\89\8b<u\cbo\eb[c\ef?&\eb\11v\9c\d9\96\bc\d4\5c\04\84\e0[\ef?`/:>\f7\ec\9a<\aa\b9h1\87T\ef?\9d8\86\cb\82\e7\8f\bc\1d\d9\fc\22PM\ef?\8d\c3\a6DAo\8a<\d6\8cb\88;F\ef?}\04\e4\b0\05z\80<\96\dc}\91I?\ef?\94\a8\a8\e3\fd\8e\96<8bunz8\ef?}Ht\f2\18^\87<?\a6\b2O\ce1\ef?\f2\e7\1f\98+G\80<\dd|\e2eE+\ef?^\08q?{\b8\96\bc\81c\f5\e1\df$\ef?1\ab\09m\e1\f7\82<\e1\de\1f\f5\9d\1e\ef?\fa\bfo\1a\9b!=\bc\90\d9\da\d0\7f\18\ef?\b4\0a\0cr\827\8b<\0b\03\e4\a6\85\12\ef?\8f\cb\ce\89\92\14n<V/>\a9\af\0c\ef?\b6\ab\b0MuM\83<\15\b71\0a\fe\06\ef?Lt\ac\e2\01B\86<1\d8L\fcp\01\ef?J\f8\d3]9\dd\8f<\ff\16d\b2\08\fc\ee?\04[\8e;\80\a3\86\bc\f1\9f\92_\c5\f6\ee?hPK\cc\edJ\92\bc\cb\a9:7\a7\f1\ee?\8e-Q\1b\f8\07\99\bcf\d8\05m\ae\ec\ee?\d26\94>\e8\d1q\bc\f7\9f\e54\db\e7\ee?\15\1b\ce\b3\19\19\99\bc\e5\a8\13\c3-\e3\ee?mL*\a7H\9f\85<\224\12L\a6\de\ee?\8ai(z`\12\93\bc\1c\80\ac\04E\da\ee?[\89\17H\8f\a7X\bc*.\f7!\0a\d6\ee?\1b\9aIg\9b,|\bc\97\a8P\d9\f5\d1\ee?\11\ac\c2`\edcC<-\89a`\08\ce\ee?\efd\06;\09f\96<W\00\1d\edA\ca\ee?y\03\a1\da\e1\ccn<\d0<\c1\b5\a2\c6\ee?0\12\0f?\8e\ff\93<\de\d3\d7\f0*\c3\ee?\b0\afz\bb\ce\90v<'*6\d5\da\bf\ee?w\e0T\eb\bd\1d\93<\0d\dd\fd\99\b2\bc\ee?\8e\a3q\004\94\8f\bc\a7,\9dv\b2\b9\ee?I\a3\93\dc\cc\de\87\bcBf\cf\a2\da\b6\ee?_8\0f\bd\c6\dex\bc\82O\9dV+\b4\ee?\f6\5c{\ecF\12\86\bc\0f\92]\ca\a4\b1\ee?\8e\d7\fd\18\055\93<\da'\b56G\af\ee?\05\9b\8a/\b7\98{<\fd\c7\97\d4\12\ad\ee?\09T\1c\e2\e1c\90<)TH\dd\07\ab\ee?\ea\c6\19P\85\c74<\b7FY\8a&\a9\ee?5\c0d+\e62\94<H!\ad\15o\a7\ee?\9fv\99aJ\e4\8c\bc\09\dcv\b9\e1\a5\ee?\a8M\ef;\c53\8c\bc\85U:\b0~\a4\ee?\ae\e9+\89xS\84\bc \c3\cc4F\a3\ee?XXVx\dd\ce\93\bc%\22U\828\a2\ee?d\19~\80\aa\10W<s\a9L\d4U\a1\ee?(\22^\bf\ef\b3\93\bc\cd;\7ff\9e\a0\ee?\82\b94\87\ad\12j\bc\bf\da\0bu\12\a0\ee?\ee\a9m\b8\efgc\bc/\1ae<\b2\9f\ee?Q\88\e0T=\dc\80\bc\84\94Q\f9}\9f\ee?\cf>Z~d\1fx\bct_\ec\e8u\9f\ee?\b0}\8b\c0J\ee\86\bct\81\a5H\9a\9f\ee?\8a\e6U\1e2\19\86\bc\c9gBV\eb\9f\ee?\d3\d4\09^\cb\9c\90<?]\deOi\a0\ee?\1d\a5M\b9\dc2{\bc\87\01\ebs\14\a1\ee?k\c0gT\fd\ec\94<2\c10\01\ed\a1\ee?Ul\d6\ab\e1\ebe<bN\cf6\f3\a2\ee?B\cf\b3/\c5\a1\88\bc\12\1a>T'\a4\ee?47;\f1\b6i\93\bc\13\ceL\99\89\a5\ee?\1e\ff\19:\84^\80\bc\ad\c7#F\1a\a7\ee?nWr\d8P\d4\94\bc\ed\92D\9b\d9\a8\ee?\00\8a\0e[g\ad\90<\99f\8a\d9\c7\aa\ee?\b4\ea\f0\c1/\b7\8d<\db\a0*B\e5\ac\ee?\ff\e7\c5\9c`\b6e\bc\8cD\b5\162\af\ee?D_\f3Y\83\f6{<6w\15\99\ae\b1\ee?\83=\1e\a7\1f\09\93\bc\c6\ff\91\0b[\b4\ee?)\1el\8b\b8\a9]\bc\e5\c5\cd\b07\b7\ee?Y\b9\90|\f9#l\bc\0fR\c8\cbD\ba\ee?\aa\f9\f4\22CC\92\bcPN\de\9f\82\bd\ee?K\8ef\d7l\ca\85\bc\ba\07\cap\f1\c0\ee?'\ce\91+\fc\afq<\90\f0\a3\82\91\c4\ee?\bbs\0a\e15\d2m<##\e3\19c\c8\ee?c\22b\22\04\c5\87\bce\e5]{f\cc\ee?\d51\e2\e3\86\1c\8b<3-J\ec\9b\d0\ee?\15\bb\bc\d3\d1\bb\91\bc]%>\b2\03\d5\ee?\d21\ee\9c1\cc\90<X\b30\13\9e\d9\ee?\b3Zsn\84i\84<\bf\fdyUk\de\ee?\b4\9d\8e\97\cd\df\82\bcz\f3\d3\bfk\e3\ee?\873\cb\92w\1a\8c<\ad\d3Z\99\9f\e8\ee?\fa\d9\d1J\8f{\90\bcf\b6\8d)\07\ee\ee?\ba\ae\dcV\d9\c3U\bc\fb\15O\b8\a2\f3\ee?@\f6\a6=\0e\a4\90\bc:Y\e5\8dr\f9\ee?4\93\ad8\f4\d6h\bcG^\fb\f2v\ff\ee?5\8aXk\e2\ee\91\bcJ\06\a10\b0\05\ef?\cd\dd_\0a\d7\fft<\d2\c1K\90\1e\0c\ef?\ac\98\92\fa\fb\bd\91\bc\09\1e\d7[\c2\12\ef?\b3\0c\af0\aens<\9cR\85\dd\9b\19\ef?\94\fd\9f\5c2\e3\8e<z\d0\ff_\ab \ef?\acY\09\d1\8f\e0\84<K\d1W.\f1'\ef?g\1aN8\af\cdc<\b5\e7\06\94m/\ef?h\19\92l,kg<i\90\ef\dc 7\ef?\d2\b5\cc\83\18\8a\80\bc\fa\c3]U\0b?\ef?o\fa\ff?]\ad\8f\bc|\89\07J-G\ef?I\a9u8\ae\0d\90\bc\f2\89\0d\08\87O\ef?\a7\07=\a6\85\a3t<\87\a4\fb\dc\18X\ef?\0f\22@ \9e\91\82\bc\98\83\c9\16\e3`\ef?\ac\92\c1\d5PZ\8e<\852\db\03\e6i\ef?Kk\01\acY:\84<`\b4\01\f3!s\ef?\1f>\b4\07!\d5\82\bc_\9b{3\97|\ef?\c9\0dG;\b9*\89\bc)\a1\f5\14F\86\ef?\d3\88:`\04\b6t<\f6?\8b\e7.\90\ef?qr\9dQ\ec\c5\83<\83L\c7\fbQ\9a\ef?\f0\91\d3\8f\12\f7\8f\bc\da\90\a4\a2\af\a4\ef?}t#\e2\98\ae\8d\bc\f1g\8e-H\af\ef?\08 \aaA\bc\c3\8e<'Za\ee\1b\ba\ef?2\eb\a9\c3\94+\84<\97\bak7+\c5\ef?\ee\85\d11\a9d\8a<@En[v\d0\ef?\ed\e3;\e4\ba7\8e\bc\14\be\9c\ad\fd\db\ef?\9d\cd\91M;\89w<\d8\90\9e\81\c1\e7\ef?\89\cc`A\c1\05S<\f1q\8f+\c2\f3\ef?\008\fa\feB.\e6?0g\c7\93W\f3.=\00\00\00\00\00\00\e0\bf`UUUUU\e5\bf\06\00\00\00\00\00\e0?NUY\99\99\99\e9?z\a4)UUU\e5\bf\e9EH\9b[I\f2\bf\c3?&\8b+\00\f0?\00\00\00\00\00\a0\f6?\00\00\00\00\00\00\00\00\00\c8\b9\f2\82,\d6\bf\80V7($\b4\fa<\00\00\00\00\00\80\f6?\00\00\00\00\00\00\00\00\00\08X\bf\bd\d1\d5\bf \f7\e0\d8\08\a5\1c\bd\00\00\00\00\00`\f6?\00\00\00\00\00\00\00\00\00XE\17wv\d5\bfmP\b6\d5\a4b#\bd\00\00\00\00\00@\f6?\00\00\00\00\00\00\00\00\00\f8-\87\ad\1a\d5\bf\d5g\b0\9e\e4\84\e6\bc\00\00\00\00\00 \f6?\00\00\00\00\00\00\00\00\00xw\95_\be\d4\bf\e0>)\93i\1b\04\bd\00\00\00\00\00\00\f6?\00\00\00\00\00\00\00\00\00`\1c\c2\8ba\d4\bf\cc\84LH/\d8\13=\00\00\00\00\00\e0\f5?\00\00\00\00\00\00\00\00\00\a8\86\860\04\d4\bf:\0b\82\ed\f3B\dc<\00\00\00\00\00\c0\f5?\00\00\00\00\00\00\00\00\00HiUL\a6\d3\bf`\94Q\86\c6\b1 =\00\00\00\00\00\a0\f5?\00\00\00\00\00\00\00\00\00\80\98\9a\ddG\d3\bf\92\80\c5\d4MY%=\00\00\00\00\00\80\f5?\00\00\00\00\00\00\00\00\00 \e1\ba\e2\e8\d2\bf\d8+\b7\99\1e{&=\00\00\00\00\00`\f5?\00\00\00\00\00\00\00\00\00\88\de\13Z\89\d2\bf?\b0\cf\b6\14\ca\15=\00\00\00\00\00`\f5?\00\00\00\00\00\00\00\00\00\88\de\13Z\89\d2\bf?\b0\cf\b6\14\ca\15=\00\00\00\00\00@\f5?\00\00\00\00\00\00\00\00\00x\cf\fbA)\d2\bfv\daS($Z\16\bd\00\00\00\00\00 \f5?\00\00\00\00\00\00\00\00\00\98i\c1\98\c8\d1\bf\04T\e7h\bc\af\1f\bd\00\00\00\00\00\00\f5?\00\00\00\00\00\00\00\00\00\a8\ab\ab\5cg\d1\bf\f0\a8\823\c6\1f\1f=\00\00\00\00\00\e0\f4?\00\00\00\00\00\00\00\00\00H\ae\f9\8b\05\d1\bffZ\05\fd\c4\a8&\bd\00\00\00\00\00\c0\f4?\00\00\00\00\00\00\00\00\00\90s\e2$\a3\d0\bf\0e\03\f4~\eek\0c\bd\00\00\00\00\00\a0\f4?\00\00\00\00\00\00\00\00\00\d0\b4\94%@\d0\bf\7f-\f4\9e\b86\f0\bc\00\00\00\00\00\a0\f4?\00\00\00\00\00\00\00\00\00\d0\b4\94%@\d0\bf\7f-\f4\9e\b86\f0\bc\00\00\00\00\00\80\f4?\00\00\00\00\00\00\00\00\00@^m\18\b9\cf\bf\87<\99\ab*W\0d=\00\00\00\00\00`\f4?\00\00\00\00\00\00\00\00\00`\dc\cb\ad\f0\ce\bf$\af\86\9c\b7&+=\00\00\00\00\00@\f4?\00\00\00\00\00\00\00\00\00\f0*n\07'\ce\bf\10\ff?TO/\17\bd\00\00\00\00\00 \f4?\00\00\00\00\00\00\00\00\00\c0Ok!\5c\cd\bf\1bh\ca\bb\91\ba!=\00\00\00\00\00\00\f4?\00\00\00\00\00\00\00\00\00\a0\9a\c7\f7\8f\cc\bf4\84\9fhOy'=\00\00\00\00\00\00\f4?\00\00\00\00\00\00\00\00\00\a0\9a\c7\f7\8f\cc\bf4\84\9fhOy'=\00\00\00\00\00\e0\f3?\00\00\00\00\00\00\00\00\00\90-t\86\c2\cb\bf\8f\b7\8b1\b0N\19=\00\00\00\00\00\c0\f3?\00\00\00\00\00\00\00\00\00\c0\80N\c9\f3\ca\bff\90\cd?cN\ba<\00\00\00\00\00\a0\f3?\00\00\00\00\00\00\00\00\00\b0\e2\1f\bc#\ca\bf\ea\c1F\dcd\8c%\bd\00\00\00\00\00\a0\f3?\00\00\00\00\00\00\00\00\00\b0\e2\1f\bc#\ca\bf\ea\c1F\dcd\8c%\bd\00\00\00\00\00\80\f3?\00\00\00\00\00\00\00\00\00P\f4\9cZR\c9\bf\e3\d4\c1\04\d9\d1*\bd\00\00\00\00\00`\f3?\00\00\00\00\00\00\00\00\00\d0 e\a0\7f\c8\bf\09\fa\db\7f\bf\bd+=\00\00\00\00\00@\f3?\00\00\00\00\00\00\00\00\00\e0\10\02\89\ab\c7\bfXJSr\90\db+=\00\00\00\00\00@\f3?\00\00\00\00\00\00\00\00\00\e0\10\02\89\ab\c7\bfXJSr\90\db+=\00\00\00\00\00 \f3?\00\00\00\00\00\00\00\00\00\d0\19\e7\0f\d6\c6\bff\e2\b2\a3j\e4\10\bd\00\00\00\00\00\00\f3?\00\00\00\00\00\00\00\00\00\90\a7p0\ff\c5\bf9P\10\9fC\9e\1e\bd\00\00\00\00\00\00\f3?\00\00\00\00\00\00\00\00\00\90\a7p0\ff\c5\bf9P\10\9fC\9e\1e\bd\00\00\00\00\00\e0\f2?\00\00\00\00\00\00\00\00\00\b0\a1\e3\e5&\c5\bf\8f[\07\90\8b\de \bd\00\00\00\00\00\c0\f2?\00\00\00\00\00\00\00\00\00\80\cbl+M\c4\bf<x5a\c1\0c\17=\00\00\00\00\00\c0\f2?\00\00\00\00\00\00\00\00\00\80\cbl+M\c4\bf<x5a\c1\0c\17=\00\00\00\00\00\a0\f2?\00\00\00\00\00\00\00\00\00\90\1e \fcq\c3\bf:T'M\86x\f1<\00\00\00\00\00\80\f2?\00\00\00\00\00\00\00\00\00\f0\1f\f8R\95\c2\bf\08\c4q\170\8d$\bd\00\00\00\00\00`\f2?\00\00\00\00\00\00\00\00\00`/\d5*\b7\c1\bf\96\a3\11\18\a4\80.\bd\00\00\00\00\00`\f2?\00\00\00\00\00\00\00\00\00`/\d5*\b7\c1\bf\96\a3\11\18\a4\80.\bd\00\00\00\00\00@\f2?\00\00\00\00\00\00\00\00\00\90\d0|~\d7\c0\bf\f4[\e8\88\96i\0a=\00\00\00\00\00@\f2?\00\00\00\00\00\00\00\00\00\90\d0|~\d7\c0\bf\f4[\e8\88\96i\0a=\00\00\00\00\00 \f2?\00\00\00\00\00\00\00\00\00\e0\db1\91\ec\bf\bf\f23\a3\5cTu%\bd\00\00\00\00\00\00\f2?\00\00\00\00\00\00\00\00\00\00+n\07'\be\bf<\00\f0*,4*=\00\00\00\00\00\00\f2?\00\00\00\00\00\00\00\00\00\00+n\07'\be\bf<\00\f0*,4*=\00\00\00\00\00\e0\f1?\00\00\00\00\00\00\00\00\00\c0[\8fT^\bc\bf\06\be_XW\0c\1d\bd\00\00\00\00\00\c0\f1?\00\00\00\00\00\00\00\00\00\e0J:m\92\ba\bf\c8\aa[\e859%=\00\00\00\00\00\c0\f1?\00\00\00\00\00\00\00\00\00\e0J:m\92\ba\bf\c8\aa[\e859%=\00\00\00\00\00\a0\f1?\00\00\00\00\00\00\00\00\00\a01\d6E\c3\b8\bfhV/M)|\13=\00\00\00\00\00\a0\f1?\00\00\00\00\00\00\00\00\00\a01\d6E\c3\b8\bfhV/M)|\13=\00\00\00\00\00\80\f1?\00\00\00\00\00\00\00\00\00`\e5\8a\d2\f0\b6\bf\das3\c97\97&\bd\00\00\00\00\00`\f1?\00\00\00\00\00\00\00\00\00 \06?\07\1b\b5\bfW^\c6a[\02\1f=\00\00\00\00\00`\f1?\00\00\00\00\00\00\00\00\00 \06?\07\1b\b5\bfW^\c6a[\02\1f=\00\00\00\00\00@\f1?\00\00\00\00\00\00\00\00\00\e0\1b\96\d7A\b3\bf\df\13\f9\cc\da^,=\00\00\00\00\00@\f1?\00\00\00\00\00\00\00\00\00\e0\1b\96\d7A\b3\bf\df\13\f9\cc\da^,=\00\00\00\00\00 \f1?\00\00\00\00\00\00\00\00\00\80\a3\ee6e\b1\bf\09\a3\8fv^|\14=\00\00\00\00\00\00\f1?\00\00\00\00\00\00\00\00\00\80\11\c00\0a\af\bf\91\8e6\83\9eY-=\00\00\00\00\00\00\f1?\00\00\00\00\00\00\00\00\00\80\11\c00\0a\af\bf\91\8e6\83\9eY-=\00\00\00\00\00\e0\f0?\00\00\00\00\00\00\00\00\00\80\19q\ddB\ab\bfLp\d6\e5z\82\1c=\00\00\00\00\00\e0\f0?\00\00\00\00\00\00\00\00\00\80\19q\ddB\ab\bfLp\d6\e5z\82\1c=\00\00\00\00\00\c0\f0?\00\00\00\00\00\00\00\00\00\c02\f6Xt\a7\bf\ee\a1\f24F\fc,\bd\00\00\00\00\00\c0\f0?\00\00\00\00\00\00\00\00\00\c02\f6Xt\a7\bf\ee\a1\f24F\fc,\bd\00\00\00\00\00\a0\f0?\00\00\00\00\00\00\00\00\00\c0\fe\b9\87\9e\a3\bf\aa\fe&\f5\b7\02\f5<\00\00\00\00\00\a0\f0?\00\00\00\00\00\00\00\00\00\c0\fe\b9\87\9e\a3\bf\aa\fe&\f5\b7\02\f5<\00\00\00\00\00\80\f0?\00\00\00\00\00\00\00\00\00\00x\0e\9b\82\9f\bf\e4\09~|&\80)\bd\00\00\00\00\00\80\f0?\00\00\00\00\00\00\00\00\00\00x\0e\9b\82\9f\bf\e4\09~|&\80)\bd\00\00\00\00\00`\f0?\00\00\00\00\00\00\00\00\00\80\d5\07\1b\b9\97\bf9\a6\fa\93T\8d(\bd\00\00\00\00\00@\f0?\00\00\00\00\00\00\00\00\00\00\fc\b0\a8\c0\8f\bf\9c\a6\d3\f6|\1e\df\bc\00\00\00\00\00@\f0?\00\00\00\00\00\00\00\00\00\00\fc\b0\a8\c0\8f\bf\9c\a6\d3\f6|\1e\df\bc\00\00\00\00\00 \f0?\00\00\00\00\00\00\00\00\00\00\10k*\e0\7f\bf\e4@\da\0d?\e2\19\bd\00\00\00\00\00 \f0?\00\00\00\00\00\00\00\00\00\00\10k*\e0\7f\bf\e4@\da\0d?\e2\19\bd\00\00\00\00\00\00\f0?\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\f0?\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\c0\ef?\00\00\00\00\00\00\00\00\00\00\89u\15\10\80?\e8+\9d\99k\c7\10\bd\00\00\00\00\00\80\ef?\00\00\00\00\00\00\00\00\00\80\93XV \90?\d2\f7\e2\06[\dc#\bd\00\00\00\00\00@\ef?\00\00\00\00\00\00\00\00\00\00\c9(%I\98?4\0cZ2\ba\a0*\bd\00\00\00\00\00\00\ef?\00\00\00\00\00\00\00\00\00@\e7\89]A\a0?S\d7\f1\5c\c0\11\01=\00\00\00\00\00\c0\ee?\00\00\00\00\00\00\00\00\00\00.\d4\aef\a4?(\fd\bdus\16,\bd\00\00\00\00\00\80\ee?\00\00\00\00\00\00\00\00\00\c0\9f\14\aa\94\a8?}&Z\d0\95y\19\bd\00\00\00\00\00@\ee?\00\00\00\00\00\00\00\00\00\c0\dd\cds\cb\ac?\07(\d8G\f2h\1a\bd\00\00\00\00\00 \ee?\00\00\00\00\00\00\00\00\00\c0\06\c01\ea\ae?{;\c9O>\11\0e\bd\00\00\00\00\00\e0\ed?\00\00\00\00\00\00\00\00\00`F\d1;\97\b1?\9b\9e\0dV]2%\bd\00\00\00\00\00\a0\ed?\00\00\00\00\00\00\00\00\00\e0\d1\a7\f5\bd\b3?\d7N\db\a5^\c8,=\00\00\00\00\00`\ed?\00\00\00\00\00\00\00\00\00\a0\97MZ\e9\b5?\1e\1d]<\06i,\bd\00\00\00\00\00@\ed?\00\00\00\00\00\00\00\00\00\c0\ea\0a\d3\00\b7?2\ed\9d\a9\8d\1e\ec<\00\00\00\00\00\00\ed?\00\00\00\00\00\00\00\00\00@Y]^3\b9?\daG\bd:\5c\11#=\00\00\00\00\00\c0\ec?\00\00\00\00\00\00\00\00\00`\ad\8d\c8j\bb?\e5h\f7+\80\90\13\bd\00\00\00\00\00\a0\ec?\00\00\00\00\00\00\00\00\00@\bc\01X\88\bc?\d3\acZ\c6\d1F&=\00\00\00\00\00`\ec?\00\00\00\00\00\00\00\00\00 \0a\839\c7\be?\e0E\e6\afh\c0-\bd\00\00\00\00\00@\ec?\00\00\00\00\00\00\00\00\00\e0\db9\91\e8\bf?\fd\0a\a1O\d64%\bd\00\00\00\00\00\00\ec?\00\00\00\00\00\00\00\00\00\e0'\82\8e\17\c1?\f2\07-\cex\ef!=\00\00\00\00\00\e0\eb?\00\00\00\00\00\00\00\00\00\f0#~+\aa\c1?4\998D\8e\a7,=\00\00\00\00\00\a0\eb?\00\00\00\00\00\00\00\00\00\80\86\0ca\d1\c2?\a1\b4\81\cbl\9d\03=\00\00\00\00\00\80\eb?\00\00\00\00\00\00\00\00\00\90\15\b0\fce\c3?\89rK#\a8/\c6<\00\00\00\00\00@\eb?\00\00\00\00\00\00\00\00\00\b03\83=\91\c4?x\b6\fdTy\83%=\00\00\00\00\00 \eb?\00\00\00\00\00\00\00\00\00\b0\a1\e4\e5'\c5?\c7}i\e5\e83&=\00\00\00\00\00\e0\ea?\00\00\00\00\00\00\00\00\00\10\8c\beNW\c6?x.<,\8b\cf\19=\00\00\00\00\00\c0\ea?\00\00\00\00\00\00\00\00\00pu\8b\12\f0\c6?\e1!\9c\e5\8d\11%\bd\00\00\00\00\00\a0\ea?\00\00\00\00\00\00\00\00\00PD\85\8d\89\c7?\05C\91p\10f\1c\bd\00\00\00\00\00`\ea?\00\00\00\00\00\00\00\00\00\009\eb\af\be\c8?\d1,\e9\aaT=\07\bd\00\00\00\00\00@\ea?\00\00\00\00\00\00\00\00\00\00\f7\dcZZ\c9?o\ff\a0X(\f2\07=\00\00\00\00\00\00\ea?\00\00\00\00\00\00\00\00\00\e0\8a<\ed\93\ca?i!VPCr(\bd\00\00\00\00\00\e0\e9?\00\00\00\00\00\00\00\00\00\d0[W\d81\cb?\aa\e1\acN\8d5\0c\bd\00\00\00\00\00\c0\e9?\00\00\00\00\00\00\00\00\00\e0;8\87\d0\cb?\b6\12TY\c4K-\bd\00\00\00\00\00\a0\e9?\00\00\00\00\00\00\00\00\00\10\f0\c6\fbo\cc?\d2+\96\c5r\ec\f1\bc\00\00\00\00\00`\e9?\00\00\00\00\00\00\00\00\00\90\d4\b0=\b1\cd?5\b0\15\f7*\ff*\bd\00\00\00\00\00@\e9?\00\00\00\00\00\00\00\00\00\10\e7\ff\0eS\ce?0\f4A`'\12\c2<\00\00\00\00\00 \e9?\00\00\00\00\00\00\00\00\00\00\dd\e4\ad\f5\ce?\11\8e\bbe\15!\ca\bc\00\00\00\00\00\00\e9?\00\00\00\00\00\00\00\00\00\b0\b3l\1c\99\cf?0\df\0c\ca\ec\cb\1b=\00\00\00\00\00\c0\e8?\00\00\00\00\00\00\00\00\00XM`8q\d0?\91N\ed\16\db\9c\f8<\00\00\00\00\00\a0\e8?\00\00\00\00\00\00\00\00\00`ag-\c4\d0?\e9\ea<\16\8b\18'=\00\00\00\00\00\80\e8?\00\00\00\00\00\00\00\00\00\e8'\82\8e\17\d1?\1c\f0\a5c\0e!,\bd\00\00\00\00\00`\e8?\00\00\00\00\00\00\00\00\00\f8\ac\cb\5ck\d1?\81\16\a5\f7\cd\9a+=\00\00\00\00\00@\e8?\00\00\00\00\00\00\00\00\00hZc\99\bf\d1?\b7\bdGQ\ed\a6,=\00\00\00\00\00 \e8?\00\00\00\00\00\00\00\00\00\b8\0emE\14\d2?\ea\baF\ba\de\87\0a=\00\00\00\00\00\e0\e7?\00\00\00\00\00\00\00\00\00\90\dc|\f0\be\d2?\f4\04PJ\fa\9c*=\00\00\00\00\00\c0\e7?\00\00\00\00\00\00\00\00\00`\d3\e1\f1\14\d3?\b8<!\d3z\e2(\bd\00\00\00\00\00\a0\e7?\00\00\00\00\00\00\00\00\00\10\bevgk\d3?\c8w\f1\b0\cdn\11=\00\00\00\00\00\80\e7?\00\00\00\00\00\00\00\00\0003wR\c2\d3?\5c\bd\06\b6T;\18=\00\00\00\00\00`\e7?\00\00\00\00\00\00\00\00\00\e8\d5#\b4\19\d4?\9d\e0\90\ec6\e4\08=\00\00\00\00\00@\e7?\00\00\00\00\00\00\00\00\00\c8q\c2\8dq\d4?u\d6g\09\ce'/\bd\00\00\00\00\00 \e7?\00\00\00\00\00\00\00\00\000\17\9e\e0\c9\d4?\a4\d8\0a\1b\89 .\bd\00\00\00\00\00\00\e7?\00\00\00\00\00\00\00\00\00\a08\07\ae\22\d5?Y\c7d\81p\be.=\00\00\00\00\00\e0\e6?\00\00\00\00\00\00\00\00\00\d0\c8S\f7{\d5?\ef@]\ee\ed\ad\1f=\00\00\00\00\00\c0\e6?\00\00\00\00\00\00\00\00\00`Y\df\bd\d5\d5?\dce\a4\08*\0b\0a\bd\19\00\0b\00\19\19\19\00\00\00\00\05\00\00\00\00\00\00\09\00\00\00\00\0b\00\00\00\00\00\00\00\00\19\00\0a\0a\19\19\19\03\0a\07\00\01\00\09\0b\18\00\00\09\06\0b\00\00\0b\00\06\19\00\00\00\19\19\19\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\00\00\00\00\19\00\0b\0d\19\19\19\00\0d\00\00\02\00\09\0e\00\00\00\09\00\0e\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0c\00\00\00\00\00\00\00\00\00\00\00\13\00\00\00\00\13\00\00\00\00\09\0c\00\00\00\00\00\0c\00\00\0c\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\00\00\00\00\00\00\00\00\00\00\00\0f\00\00\00\04\0f\00\00\00\00\09\10\00\00\00\00\00\10\00\00\10\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\12\00\00\00\00\00\00\00\00\00\00\00\11\00\00\00\00\11\00\00\00\00\09\12\00\00\00\00\00\12\00\00\12\00\00\1a\00\00\00\1a\1a\1a\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\1a\00\00\00\1a\1a\1a\00\00\00\00\00\00\09\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\14\00\00\00\00\00\00\00\00\00\00\00\17\00\00\00\00\17\00\00\00\00\09\14\00\00\00\00\00\14\00\00\14\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\16\00\00\00\00\00\00\00\00\00\00\00\15\00\00\00\00\15\00\00\00\00\09\16\00\00\00\00\00\16\00\00\16\00\000123456789ABCDEFNo error information\00Illegal byte sequence\00Domain error\00Result not representable\00Not a tty\00Permission denied\00Operation not permitted\00No such file or directory\00No such process\00File exists\00Value too large for data type\00No space left on device\00Out of memory\00Resource busy\00Interrupted system call\00Resource temporarily unavailable\00Invalid seek\00Cross-device link\00Read-only file system\00Directory not empty\00Connection reset by peer\00Operation timed out\00Connection refused\00Host is down\00Host is unreachable\00Address in use\00Broken pipe\00I/O error\00No such device or address\00Block device required\00No such device\00Not a directory\00Is a directory\00Text file busy\00Exec format error\00Invalid argument\00Argument list too long\00Symbolic link loop\00Filename too long\00Too many open files in system\00No file descriptors available\00Bad file descriptor\00No child process\00Bad address\00File too large\00Too many links\00No locks available\00Resource deadlock would occur\00State not recoverable\00Previous owner died\00Operation canceled\00Function not implemented\00No message of desired type\00Identifier removed\00Device not a stream\00No data available\00Device timeout\00Out of streams resources\00Link has been severed\00Protocol error\00Bad message\00File descriptor in bad state\00Not a socket\00Destination address required\00Message too large\00Protocol wrong type for socket\00Protocol not available\00Protocol not supported\00Socket type not supported\00Not supported\00Protocol family not supported\00Address family not supported by protocol\00Address not available\00Network is down\00Network unreachable\00Connection reset by network\00Connection aborted\00No buffer space available\00Socket is connected\00Socket not connected\00Cannot send after socket shutdown\00Operation already in progress\00Operation in progress\00Stale file handle\00Remote I/O error\00Quota exceeded\00No medium found\00Wrong medium type\00Multihop attempted\00Required key not available\00Key has expired\00Key has been revoked\00Key was rejected by service\00\00\00\00\00\00\00\00\00\a5\02[\00\f0\01\b5\05\8c\05%\01\83\06\1d\03\94\04\ff\00\c7\031\03\0b\06\bc\01\8f\01\7f\03\ca\04+\00\da\06\af\00B\03N\03\dc\01\0e\04\15\00\a1\06\0d\01\94\02\0b\028\06d\02\bc\02\ff\02]\03\e7\04\0b\07\cf\02\cb\05\ef\05\db\05\e1\02\1e\06E\02\85\00\82\02l\03o\04\f1\00\f3\03\18\05\d9\00\da\03L\06T\02{\01\9d\03\bd\04\00\00Q\00\15\02\bb\00\b3\03m\00\ff\01\85\04/\05\f9\048\00e\01F\01\9f\00\b7\06\a8\01s\02S\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00!\04\00\00\00\00\00\00\00\00/\02\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\005\04G\04V\04\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\a0\04\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00F\05`\05n\05a\06\00\00\cf\01\00\00\00\00\00\00\00\00\c9\06\e9\06\f9\06\1e\079\07I\07^\07")
  (data $.data (i32.const 74696) "\00 \00\00\00\00\00\00\05\00\00\00\00\00\00\00\00\00\00\00\04\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\00\00\06\00\00\00\5c&\01\00\00\00\00\00\00\00\00\00\00\00\00\00\02\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\ff\ff\ff\ff\ff\ff\ff\ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\d0#\01\00P(\01\00")
  (data $em_js (i32.const 74856) "(char *input_ptr, char *output_ptr)<::>{ var inputStr = UTF8ToString(input_ptr); var sanitizedStr = DOMPurify.sanitize(inputStr); var encodedStr = new TextEncoder().encode(sanitizedStr); Module.HEAPU8.set(encodedStr, output_ptr); return encodedStr.length; }\00"))
