import { useState } from "react";
import "./App.css";
import { supabase } from "./lib/config"
import { FaRegEye, FaRegEyeSlash } from 'react-icons/fa';

const App: React.FC = () => {
  const [email, setEmail] = useState<string>('');
  const [password, setPassword] = useState<string>('');
  const [passwordCheck, setPasswordCheck] = useState<string>('');
  const [isPasswordVisible, setIsPasswordVisible] = useState<boolean>(false);
  const [isPasswordCheckVisible, setIsPasswordCheckVisible] = useState<boolean>(false);

  const showAlert = (msg: string) => {
    alert(msg);
  };

  const signup = async (): Promise<void> => {
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

  const signin = async (): Promise<void> => {
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

  return (
    <main className="flex justify-center items-center h-screen flex-col">
      <label htmlFor="email">이메일</label>
      <input
        type="email"
        id="email"
        className="outline p-2 border"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />

      <label htmlFor="password">패스워드</label>
      <div className="relative">
        <input
          type={isPasswordVisible ? "text" : "password"}
          id="password"
          className="outline p-2 border pr-10"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <button
          type="button"
          className="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-500"
          onClick={() => setIsPasswordVisible(!isPasswordVisible)}
        >
          {isPasswordVisible ? <FaRegEyeSlash /> : <FaRegEye />}
        </button>
      </div>

      <label htmlFor="passwordCheck">패스워드 확인</label>
      <div className="relative">
        <input
          type={isPasswordCheckVisible ? "text" : "password"}
          id="passwordCheck"
          className="outline p-2 border pr-10"
          value={passwordCheck}
          onChange={(e) => setPasswordCheck(e.target.value)}
        />
        <button
          type="button"
          className="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-500"
          onClick={() => setIsPasswordCheckVisible(!isPasswordCheckVisible)}
        >
          {isPasswordCheckVisible ? <FaRegEyeSlash /> : <FaRegEye />}
        </button>
      </div>

      <button onClick={signup}>회원가입</button>
      <button onClick={signin}>로그인</button>
    </main>
  );
};

export default App;
