import flet as ft
from pydantic import ValidationError
from config import supabase
from models import EmailModel

def main(page: ft.Page):
  email = ft.TextField()
  password = ft.TextField(password=True, can_reveal_password=True)
  password_check = ft.TextField(password=True, can_reveal_password=True)

  def open_snackbar(message: str):
    page.snack_bar = ft.SnackBar(ft.Text(message))
    page.snack_bar.open = True
    page.update()

  def signup_request(_):
    try:
      if not email.value or not password.value or not password_check.value:
          open_snackbar("이메일, 패스워드, 패스워드확인란을 입력해주세요.")
          return

      if password.value != password_check.value:
          open_snackbar("패스워드가 일치하지 않습니다.")
          return

      if len(password.value) < 6:
          open_snackbar("패스워드는 6자리 이상이어야 합니다.")
          return
              
      try:
        emailmodel = EmailModel(email=email.value)
      except ValidationError as e:
        open_snackbar("이메일형식으로 입력해주세요.")
        return

      response = supabase.auth.sign_up(
          {"email": emailmodel.email, "password": password.value}
      )
      open_snackbar(f"{response.user.email} 회원가입에 성공하였습니다.")
    except Exception as e:
        print({e})
        open_snackbar(f"오류 발생: {e}") 

  def signin_request(_):     
    try:
      if not email.value or not password.value:
          open_snackbar("이메일, 패스워드를 입력해주세요.")
          return

      if len(password.value) < 6:
          open_snackbar("패스워드는 6자리 이상이어야 합니다.")
          return
              
      try:
        emailmodel = EmailModel(email=email.value)
      except ValidationError as e:
        open_snackbar("이메일형식으로 입력해주세요.")
        return

      response = supabase.auth.sign_in_with_password(
          {"email": emailmodel.email, "password": password.value}
      )
      open_snackbar(f"{response.user.email} 로그인에 성공하였습니다.")
    except Exception as e:
        print({e})
        open_snackbar(f"오류 발생: {e}") 
  
  page.add(
    ft.Text("이메일"),
    email,    
    ft.Text("패스워드"),
    password,
    ft.Text("패스워드확인"),
    password_check,
    ft.TextButton(text="회원가입", on_click=signup_request),
    ft.TextButton(text="로그인", on_click=signin_request),
  )

ft.app(main)