<script lang="ts">
  import { supabase } from "$lib/config";
  import { FaRegEye, FaRegEyeSlash } from "svelte-icons/fa";

  let email = $state<string | null>("");
  let password = $state<string | null>("");
  let passwordCheck = $state<string | null>("");
  let isPasswordVisible = $state<boolean>(false);
  let isPasswordCheckVisible = $state<boolean>(false);

  const showAlert = (msg: string) => {
    alert(msg);
  };

  const signup = async () => {
    if (!email || !password || !passwordCheck) {
      showAlert("이메일, 패스워드, 패스워드확인란을 입력해주세요.");
      return;
    }

    if (password !== passwordCheck) {
      showAlert("패스워드가 일치하지 않습니다.");
      return;
    }

    if (password.length < 6) {
      showAlert("패스워드는 6자리 이상이어야 합니다.");
      return;
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      showAlert("이메일 형식으로 입력해주세요.");
      return;
    }

    try {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
      });

      if (error) throw error;

      showAlert(`${data.user?.email} 회원가입에 성공하였습니다.`);
    } catch (error: unknown) {
      if (error instanceof Error) {
        showAlert(`오류 발생: ${error.message}`);
      } else {
        showAlert("알 수 없는 오류가 발생했습니다.");
      }
    }
  };

  const signin = async () => {
    if (!email || !password) {
      showAlert("이메일, 패스워드를 입력해주세요.");
      return;
    }

    if (password.length < 6) {
      showAlert("패스워드는 6자리 이상이어야 합니다.");
      return;
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      showAlert("이메일 형식으로 입력해주세요.");
      return;
    }

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;

      showAlert(`${data.user?.email} 로그인에 성공하였습니다.`);
    } catch (error: unknown) {
      if (error instanceof Error) {
        showAlert(`오류 발생: ${error.message}`);
      } else {
        showAlert("알 수 없는 오류가 발생했습니다.");
      }
    }
  };
</script>

<main class="flex justify-center items-center h-screen flex-col">
  <label for="email">이메일</label>
  <input type="email" id="email" class="outline" bind:value={email} />
  <label for="password">패스워드</label>
  <div class="relative">
    <input
      type={isPasswordVisible ? "text" : "password"}
      id="password"
      class="outline"
      bind:value={password}
    />
    <button
      type="button"
      class="absolute right-1 top-1/2 -translate-y-1/2 w-6 text-gray-300"
      onclick={() => (isPasswordVisible = !isPasswordVisible)}
    >
      {#if isPasswordVisible}
        <FaRegEyeSlash />
      {:else}
        <FaRegEye />
      {/if}
    </button>
  </div>
  <label for="passwordCheck">패스워드 확인</label>
  <div class="relative">
    <input
      type={isPasswordCheckVisible ? "text" : "password"}
      id="passwordCheck"
      class="outline"
      bind:value={passwordCheck}
    />
    <button
      type="button"
      class="absolute right-1 top-1/2 -translate-y-1/2 w-6 text-gray-300"
      onclick={() => (isPasswordCheckVisible = !isPasswordCheckVisible)}
    >
      {#if isPasswordCheckVisible}
        <FaRegEyeSlash />
      {:else}
        <FaRegEye />
      {/if}
    </button>
  </div>

  <button onclick={signup}>회원가입</button>
  <button onclick={signin}>로그인</button>
</main>
